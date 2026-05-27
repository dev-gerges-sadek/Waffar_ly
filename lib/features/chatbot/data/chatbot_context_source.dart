import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';

/// Builds the live-data context block injected into every AI prompt turn.
///
/// Design contract:
///   • Missing / zero values → [_absent] sentinel, never surfaced to the user.
///   • The sentinel instruction block is rendered in the active locale so the
///     model always produces language-matching fallback prose.
///   • Each Firestore section is independently guarded — one failure never
///     blocks the others.
class ChatbotContextSource {
  ChatbotContextSource() : _firestore = FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // Sentinel — consumed only by the AI; never shown to the user.
  static const _absent = '__ABSENT__';

  // ── Typed field readers ───────────────────────────────────────────────────

  static String _n(
    Map<String, dynamic> d,
    String key, {
    String unit = '',
    int dec = 1,
  }) {
    final v = d[key];
    if (v == null) return _absent;
    final n = (v as num).toDouble();
    if (n == 0.0) return _absent;
    final s = n == n.truncateToDouble()
        ? n.toInt().toString()
        : n.toStringAsFixed(dec);
    return unit.isEmpty ? s : '$s $unit';
  }

  static String _s(Map<String, dynamic> d, String key) {
    final v = d[key]?.toString().trim();
    return (v == null || v.isEmpty) ? _absent : v;
  }

  static String _b(Map<String, dynamic> d, String key) {
    final v = d[key];
    return v == null ? _absent : v.toString();
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Builds the full context block.
  /// [isArabic] renders sentinel/fallback instructions in Arabic so the model
  /// produces natural Arabic prose when data is missing.
  Future<String> buildContext({required bool isArabic}) async {
    final parts = <String>[];

    // 1 — Real device AI output
    await _addFlat(parts, 'LIVE_AI_REAL_DEVICE', () async {
      final snap = await _doc(
          AppConstants.colAiResults, AppConstants.docRealDevice);
      if (!snap.exists) return null;
      final d = snap.data()!;
      return {
        'status':         _s(d, 'ai_decision'),
        'live_watts':     _n(d, 'watts',            unit: 'W'),
        'total_kwh':      _n(d, 'kwh_consumed',     unit: 'kWh'),
        'bill_egp':       _n(d, 'cost_so_far_egp',  unit: 'EGP'),
        'recommendation': _s(d, 'recommendation'),
        'last_updated':   _s(d, 'timestamp'),
      };
    });

    // 2 — Per-device states
    await _addDeviceStates(parts);

    // 3 — Simulator AI result
    await _addFlat(parts, 'SIMULATOR_AI', () async {
      final snap = await _doc(
          AppConstants.colAiResults, AppConstants.docSimulator);
      if (!snap.exists) return null;
      final d = snap.data()!;
      return {
        'decision':       _s(d, 'ai_decision'),
        'watts':          _n(d, 'watts',             unit: 'W'),
        'amps':           _n(d, 'amperes',           unit: 'A'),
        'volts':          _n(d, 'voltage',           unit: 'V'),
        'kwh':            _n(d, 'kwh_consumed',      unit: 'kWh'),
        'bill_egp':       _n(d, 'cost_so_far_egp',   unit: 'EGP'),
        'prob_anomaly':   _n(d, 'prob_anomaly_pct',  unit: '%', dec: 1),
        'prob_normal':    _n(d, 'prob_normal_pct',   unit: '%', dec: 1),
        'temp_c':         _n(d, 'temperature_c',     unit: '°C'),
        'humidity_pct':   _n(d, 'humidity_pct',      unit: '%'),
        'recommendation': _s(d, 'recommendation'),
      };
    });

    // 4 — Hardware AI result
    await _addFlat(parts, 'HARDWARE_AI', () async {
      final snap = await _doc(
          AppConstants.colAiResults, AppConstants.docHardware);
      if (!snap.exists) return null;
      final d = snap.data()!;
      return {
        'decision':       _s(d, 'ai_decision'),
        'watts':          _n(d, 'watts', unit: 'W'),
        'is_anomaly':     _b(d, 'is_anomaly'),
        'recommendation': _s(d, 'recommendation'),
      };
    });

    return parts.isEmpty
        ? _noDataBlock(isArabic)
        : _dataBlock(parts, isArabic);
  }

  // ── Context block builders ────────────────────────────────────────────────

  /// Rendered when Firestore returns zero documents.
  /// Written in the active locale so the model's fallback prose matches.
  String _noDataBlock(bool isArabic) {
    if (isArabic) {
      return '''
حالة_البيانات: لا_توجد_بيانات_مباشرة

تعليمات للنموذج (لا تعرضها للمستخدم):
  • لا تتوفر بيانات مباشرة من نظام المنزل الذكي في الوقت الحالي.
  • أجب بأسلوب دافئ وطبيعي دون ذكر "N/A" أو "غير متاح" أو "لا توجد بيانات".
  • أخبر المستخدم بلطف أن البيانات المباشرة لم تتزامن بعد.
  • قدّم نصيحة عملية أو معلومة مفيدة مرتبطة بسؤاله.
  • إذا كان السؤال عاماً (نصائح توفير الطاقة، استكشاف الأخطاء، أسعار الكهرباء...) أجب عليه بالكامل.
''';
    }
    return '''
DATA_STATUS: NO_LIVE_DATA

Model instructions (do not expose to user):
  - No live data is available from the smart home system right now.
  - Respond warmly without saying "N/A", "unavailable", or "no data".
  - Gently acknowledge that live data hasn't synced yet.
  - Provide a practical tip or helpful context related to the question.
  - For general questions (energy tips, troubleshooting, tariffs...) answer fully.
''';
  }

  /// Rendered when at least one Firestore section succeeded.
  String _dataBlock(List<String> parts, bool isArabic) {
    if (isArabic) {
      return '''
تعليمات للقيم الغائبة (لا تعرضها للمستخدم):
  أي حقل يحمل القيمة "__ABSENT__" لم يتزامن بعد من الجهاز.
  القواعد:
    - لا تُخرج "__ABSENT__" أو "N/A" أو "غير متاح" للمستخدم أبداً.
    - قل بأسلوب طبيعي مثل: "هذا القياس لم يصلني بعد — قد يكون لا يزال يتزامن.
      لكن يمكنني إخبارك بـ..."
    - أكمل دائماً بنصيحة عملية أو سياق مفيد لنفس الموضوع.
    - إذا كانت بيانات أخرى متاحة، استخدمها للإجابة.

${parts.join('\n\n')}
''';
    }
    return '''
ABSENT_SENTINEL_INSTRUCTION (do not expose to user):
  Any field reading "__ABSENT__" has not yet synced from the hardware.
  Rules:
    - NEVER output "__ABSENT__", "N/A", or "not available" to the user.
    - Acknowledge naturally: "That reading hasn't come through yet — still syncing.
      Here is what I can tell you..."
    - Always follow up with a practical tip or helpful context on the same topic.
    - If other data is available, use it to give a partial but useful answer.

${parts.join('\n\n')}
''';
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  Future<DocumentSnapshot<Map<String, dynamic>>> _doc(
    String collection,
    String docId,
  ) =>
      _firestore
          .collection(collection)
          .doc(docId)
          .get()
          .timeout(const Duration(seconds: 10));

  Future<void> _addFlat(
    List<String> parts,
    String section,
    Future<Map<String, String>?> Function() fetch,
  ) async {
    try {
      final data = await fetch();
      if (data == null || data.isEmpty) return;
      final buf = StringBuffer('[$section]\n');
      data.forEach((k, v) => buf.writeln('  $k: $v'));
      parts.add(buf.toString().trimRight());
    } catch (e) {
      debugPrint('[ChatbotContextSource] $section error: $e');
    }
  }

  Future<void> _addDeviceStates(List<String> parts) async {
    try {
      final snap = await _firestore
          .collection(AppConstants.colDeviceStates)
          .get()
          .timeout(const Duration(seconds: 10));
      if (snap.docs.isEmpty) return;
      final buf = StringBuffer('[DEVICE_STATES]\n');
      for (final doc in snap.docs) {
        final d      = doc.data();
        final watts  = _n(d, 'watts',  unit: 'W');
        final status = _s(d, 'status');
        buf.writeln('  ${doc.id}: watts=$watts  status=$status');
      }
      parts.add(buf.toString().trimRight());
    } catch (e) {
      debugPrint('[ChatbotContextSource] DEVICE_STATES error: $e');
    }
  }
}
