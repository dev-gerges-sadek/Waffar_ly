import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waffar_ly_app/core/l10n/app_localizations.dart';

Map<String, dynamic> _arb(String lang) =>
    jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync())
        as Map<String, dynamic>;

bool _hasArabic(String s) => RegExp(r'[؀-ۿ]').hasMatch(s);

void main() {
  final en = _arb('en');
  final ar = _arb('ar');
  final keys = en.keys.where((k) => !k.startsWith('@'));

  test('English and Arabic ARB files define exactly the same keys', () {
    final arKeys = ar.keys.where((k) => !k.startsWith('@')).toSet();
    expect(arKeys.difference(keys.toSet()), isEmpty);
    expect(keys.toSet().difference(arKeys), isEmpty);
  });

  test('every Arabic value contains Arabic text (or is intentionally neutral)', () {
    const neutral = {'electricityRateHint', 'emailHint', 'appName'};
    for (final k in keys.where((k) => !k.startsWith('@@'))) {
      if (neutral.contains(k)) continue;
      final v = ar[k] as String;
      expect(_hasArabic(v), isTrue, reason: 'Arabic text missing for "$k"');
    }
  });

  test('English values never contain Arabic', () {
    for (final k in keys.where((k) => !k.startsWith('@@'))) {
      expect(_hasArabic(en[k] as String), isFalse, reason: k);
    }
  });

  group('Arabic plural rules', () {
    final l = lookupAppLocalizations(const Locale('ar'));
    test('devicesTurnedOff', () {
      expect(l.devicesTurnedOff(1), 'تم إطفاء جهاز واحد');
      expect(l.devicesTurnedOff(2), 'تم إطفاء جهازين');
      expect(l.devicesTurnedOff(5), 'تم إطفاء 5 أجهزة');
      expect(l.devicesTurnedOff(11), 'تم إطفاء 11 جهازاً');
    });
    test('english', () {
      final e = lookupAppLocalizations(const Locale('en'));
      expect(e.devicesTurnedOff(1), '1 device turned off');
      expect(e.devicesTurnedOff(3), '3 devices turned off');
    });
  });

  group('device name translation', () {
    final ar = lookupAppLocalizations(const Locale('ar'));
    final en = lookupAppLocalizations(const Locale('en'));
    test('structured ids are localised', () {
      expect(ar.translateDeviceOrRoomName('Lamp_LR_01'), 'مصباح · غرفة المعيشة 1');
      expect(en.translateDeviceOrRoomName('Lamp LR 01'), 'Lamp · Living Room 1');
      expect(ar.translateDeviceOrRoomName('Real_Device_01'), 'الجهاز الفعلي 1');
    });
    test('unknown names pass through', () {
      expect(ar.translateDeviceOrRoomName('Something'), 'Something');
    });
  });
}
