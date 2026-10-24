// One-off migration: copies the old GLOBAL collections into one household.
//
//   cd tools && npm i firebase-admin
//   GOOGLE_APPLICATION_CREDENTIALS=serviceAccount.json \
//     node migrate_to_homes.js <ownerUid> [--dry-run]
//
// Safe to re-run (uses set/merge). Old data is NOT deleted - verify the app
// against the new paths first, then delete the legacy collections manually.
const admin = require('firebase-admin');

const COLLECTIONS = [
  'device_states', 'Control', 'Devices', 'ai_results',
  'device_history', 'device_alerts', 'energy_daily',
];

async function main() {
  const [ownerUid, flag] = process.argv.slice(2);
  if (!ownerUid) {
    console.error('usage: node migrate_to_homes.js <ownerUid> [--dry-run]');
    process.exit(1);
  }
  const dry = flag === '--dry-run';
  admin.initializeApp();
  const db = admin.firestore();
  const home = db.collection('homes').doc(ownerUid);

  if (!dry) {
    await home.set(
      {
        owner: ownerUid,
        members: [ownerUid],
        created_at: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
  }

  for (const name of COLLECTIONS) {
    const snap = await db.collection(name).get();
    console.log(`${name}: ${snap.size} document(s)`);
    if (dry) continue;
    let batch = db.batch();
    let n = 0;
    for (const doc of snap.docs) {
      batch.set(home.collection(name).doc(doc.id), doc.data(), { merge: true });
      if (++n % 400 === 0) {
        await batch.commit();
        batch = db.batch();
      }
    }
    await batch.commit();
  }
  console.log(dry ? 'dry run finished' : 'migration finished');
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
