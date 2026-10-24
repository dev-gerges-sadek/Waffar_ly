import 'package:flutter_test/flutter_test.dart';
import 'package:waffar_ly_app/features/ai_dashboard/models/ai_result.dart';
import 'package:waffar_ly_app/features/ai_dashboard/utils/ai_utilities.dart';

void main() {
  group('AiUtilities.computeSeverity', () {
    test('idle is normal', () {
      expect(AiUtilities.computeSeverity(0, 0), AiSeverity.normal);
    });

    test('thresholds escalate', () {
      expect(AiUtilities.computeSeverity(50, 0.5), AiSeverity.normal);
      expect(AiUtilities.computeSeverity(100, 0.5), AiSeverity.warning);
      expect(AiUtilities.computeSeverity(150, 0.5), AiSeverity.danger);
      expect(AiUtilities.computeSeverity(200, 0.5), AiSeverity.critical);
      expect(AiUtilities.computeSeverity(10, 3), AiSeverity.critical);
    });
  });

  group('AiUtilities.sanitise', () {
    test('all-zero readings -> idle', () {
      final r = AiUtilities.sanitise({'watts': 0, 'amperes': 0}, 'sim');
      expect(r.isIdle, isTrue);
    });

    test('string-typed telemetry does not throw', () {
      final r = AiUtilities.sanitise({
        'watts': '120.5',
        'amperes': 'oops',
        'kwh_consumed': 1,
        'voltage': 220,
        'ai_decision': 'NORMAL',
      }, 'hw');
      expect(r.watts, 120.5);
      expect(r.amperes, 0);
    });
  });

  test('roomFromDeviceId maps suffixes and falls back to Other', () {
    expect(AiUtilities.roomFromDeviceId('Lamp_LR_01'), 'Living Room');
    expect(AiUtilities.roomFromDeviceId('Thing'), 'Other');
  });
}
