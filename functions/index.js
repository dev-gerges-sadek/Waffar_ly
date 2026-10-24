/**
 * Waffar backend proxy.
 *
 * Keeps third-party API keys (Groq, WeatherAPI) out of the mobile app:
 *   - every call must carry a valid Firebase Auth ID token (callable functions
 *     verify it automatically; App Check is enforced when enabled),
 *   - inputs are validated and size-limited,
 *   - each user is rate-limited.
 *
 * Deploy:
 *   firebase functions:secrets:set GROQ_API_KEY
 *   firebase functions:secrets:set WEATHER_API_KEY
 *   firebase deploy --only functions
 */
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const admin = require('firebase-admin');

admin.initializeApp();

const GROQ_API_KEY = defineSecret('GROQ_API_KEY');
const WEATHER_API_KEY = defineSecret('WEATHER_API_KEY');

const GROQ_MODEL = 'llama-3.3-70b-versatile';
const MAX_MESSAGES = 24;
const MAX_TOTAL_CHARS = 14000;
const ROLES = new Set(['system', 'user', 'assistant']);

// ---- per-user rate limiting (fixed window, transactional) -----------------
async function enforceRateLimit(uid, bucket, limit, windowMs) {
  const ref = admin.firestore().collection('rate_limits').doc(`${bucket}_${uid}`);
  const now = Date.now();
  await admin.firestore().runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const d = snap.exists ? snap.data() : { start: now, count: 0 };
    const fresh = now - d.start > windowMs;
    const start = fresh ? now : d.start;
    const count = fresh ? 1 : d.count + 1;
    if (count > limit) {
      throw new HttpsError('resource-exhausted', 'rate_limited');
    }
    tx.set(ref, { start, count });
  });
}

function requireAuth(request) {
  if (!request.auth) {
    throw new HttpsError('unauthenticated', 'sign_in_required');
  }
  return request.auth.uid;
}

// ---- Groq chat ------------------------------------------------------------
exports.groqChat = onCall(
  { secrets: [GROQ_API_KEY], region: 'europe-west1', timeoutSeconds: 30, enforceAppCheck: false },
  async (request) => {
    const uid = requireAuth(request);
    await enforceRateLimit(uid, 'chat', 20, 60 * 1000);

    const messages = request.data && request.data.messages;
    if (!Array.isArray(messages) || messages.length === 0 || messages.length > MAX_MESSAGES) {
      throw new HttpsError('invalid-argument', 'bad_messages');
    }
    let total = 0;
    const clean = messages.map((m) => {
      if (!m || !ROLES.has(m.role) || typeof m.content !== 'string') {
        throw new HttpsError('invalid-argument', 'bad_message');
      }
      total += m.content.length;
      return { role: m.role, content: m.content };
    });
    if (total > MAX_TOTAL_CHARS) {
      throw new HttpsError('invalid-argument', 'too_long');
    }

    let res;
    try {
      res = await fetch('https://api.groq.com/openai/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${GROQ_API_KEY.value()}`,
        },
        body: JSON.stringify({
          model: GROQ_MODEL, // fixed server-side: clients cannot pick models
          messages: clean,
          max_tokens: 450,
          temperature: 0.6,
          top_p: 0.92,
        }),
      });
    } catch (e) {
      throw new HttpsError('unavailable', 'upstream_unreachable');
    }

    if (res.status === 429) throw new HttpsError('resource-exhausted', 'upstream_rate_limited');
    if (!res.ok) throw new HttpsError('internal', 'upstream_error');

    const data = await res.json();
    const reply = data?.choices?.[0]?.message?.content ?? '';
    return { reply: String(reply).slice(0, 4000) };
  },
);

// ---- Weather --------------------------------------------------------------
exports.weatherForecast = onCall(
  { secrets: [WEATHER_API_KEY], region: 'europe-west1', timeoutSeconds: 15, enforceAppCheck: false },
  async (request) => {
    const uid = requireAuth(request);
    await enforceRateLimit(uid, 'weather', 30, 60 * 1000);

    const city = request.data && request.data.city;
    if (typeof city !== 'string' || city.trim().length === 0 || city.length > 80) {
      throw new HttpsError('invalid-argument', 'bad_city');
    }

    const url = new URL('https://api.weatherapi.com/v1/forecast.json');
    url.searchParams.set('key', WEATHER_API_KEY.value());
    url.searchParams.set('q', city.trim());
    url.searchParams.set('days', '3');
    url.searchParams.set('aqi', 'no');
    url.searchParams.set('alerts', 'no');

    let res;
    try {
      res = await fetch(url);
    } catch (e) {
      throw new HttpsError('unavailable', 'upstream_unreachable');
    }
    if (res.status === 400) throw new HttpsError('not-found', 'city_not_found');
    if (!res.ok) throw new HttpsError('internal', 'upstream_error');
    return { forecast: await res.json() };
  },
);
