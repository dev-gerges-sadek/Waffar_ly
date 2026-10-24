/// Tolerant readers for loosely-typed Firestore / JSON values.
///
/// Telemetry written by the ESP32 or a backend can contain numbers as
/// strings, nulls, or unexpected types. A hard `as num` cast would throw and
/// kill the whole stream - these helpers degrade to null instead.
double? asDouble(Object? v) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

int? asInt(Object? v) {
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

String? asString(Object? v) => v == null ? null : (v is String ? v : '$v');

bool? asBool(Object? v) {
  if (v is bool) return v;
  if (v is String) {
    final l = v.toLowerCase();
    if (l == 'true') return true;
    if (l == 'false') return false;
  }
  return null;
}
