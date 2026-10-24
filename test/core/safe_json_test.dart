import 'package:flutter_test/flutter_test.dart';
import 'package:waffar_ly_app/core/helper/safe_json.dart';

void main() {
  group('safe_json', () {
    test('asDouble accepts num and numeric strings, rejects the rest', () {
      expect(asDouble(3), 3.0);
      expect(asDouble(2.5), 2.5);
      expect(asDouble('4.25'), 4.25);
      expect(asDouble('abc'), isNull);
      expect(asDouble(null), isNull);
      expect(asDouble(true), isNull);
    });

    test('asInt / asBool / asString are tolerant', () {
      expect(asInt(7.9), 7);
      expect(asInt('12'), 12);
      expect(asInt('x'), isNull);
      expect(asBool('TRUE'), true);
      expect(asBool('false'), false);
      expect(asBool(1), isNull);
      expect(asString(5), '5');
      expect(asString(null), isNull);
    });
  });
}
