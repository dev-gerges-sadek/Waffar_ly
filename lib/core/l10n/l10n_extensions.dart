import 'gen/app_localizations.dart';

/// Helpers layered on top of the generated [AppLocalizations].
extension AppLocalizationsX on AppLocalizations {
  bool get isArabic => localeName == 'ar';

  /// Text direction-aware severity / health labels live in ARB; the helpers
  /// below translate *dynamic* backend strings (device ids, room names, AI
  /// recommendations) that cannot be expressed as static ARB keys.

  // ── Room label helper ─────────────────────────────────────────────────────
  String roomLabel(String roomKey) {
    if (!isArabic) return roomKey;
    const map = {
      'Living Room': 'غرفة المعيشة',
      'Bedroom': 'غرفة النوم',
      'Kitchen': 'المطبخ',
      'Bathroom': 'الحمام',
      'Room 2': 'الغرفة 2',
      'Other': 'أخرى',
    };
    return map[roomKey] ?? roomKey;
  }

  // Device ids look like `Lamp_LR_01` / `AC_BR_01` / `Real_Device_01`.
  static const _typeEn = {
    'LAMP': 'Lamp', 'FAN': 'Fan', 'TV': 'TV', 'AC': 'Air conditioner',
    'FRIDGE': 'Fridge', 'HEATER': 'Heater', 'WASHER': 'Washer',
    'SPEAKER': 'Speaker', 'REAL': 'Real device',
  };
  static const _typeAr = {
    'LAMP': 'مصباح', 'FAN': 'مروحة', 'TV': 'تلفاز', 'AC': 'تكييف',
    'FRIDGE': 'ثلاجة', 'HEATER': 'سخان', 'WASHER': 'غسالة',
    'SPEAKER': 'سماعة', 'REAL': 'الجهاز الفعلي',
  };
  static const _roomEn = {
    'LR': 'Living Room', 'BR': 'Bedroom', 'K': 'Kitchen',
    'B': 'Bathroom', 'R2': 'Room 2',
  };
  static const _roomAr = {
    'LR': 'غرفة المعيشة', 'BR': 'غرفة النوم', 'K': 'المطبخ',
    'B': 'الحمام', 'R2': 'الغرفة 2',
  };

  /// `Lamp_LR_01` -> "مصباح · غرفة المعيشة 1" / "Lamp · Living Room 1".
  /// Returns null when [raw] is not a structured device id.
  String? _structuredDeviceName(String raw) {
    final parts = raw.trim().split(RegExp(r'[_\s]+'));
    if (parts.length < 2) return null;
    final type = parts.first.toUpperCase();
    final types = isArabic ? _typeAr : _typeEn;
    if (!types.containsKey(type)) return null;
    final number = int.tryParse(parts.last);
    final roomCode = parts.length >= 3 ? parts[1].toUpperCase() : null;
    final rooms = isArabic ? _roomAr : _roomEn;
    final room = roomCode == null ? null : rooms[roomCode];
    if (type == 'REAL') {
      return '${types[type]}${number == null ? '' : ' $number'}';
    }
    if (room == null && number == null) return null;
    final tail = [?room, if (number != null) '$number'];
    return '${types[type]} · ${tail.join(' ')}';
  }

  // ── Device and Room Name Translation ──────────────────────────────────────
  String translateDeviceOrRoomName(String name) {
    final structured = _structuredDeviceName(name);
    if (structured != null) return structured;
    if (!isArabic) return name;

    // Device names mapping
    const deviceMap = {
      'AC_UNIT': 'وحدة تكييف الهواء',
      'AC': 'تكييف الهواء',
      'WATER_HEATER': 'سخان المياه',
      'WATER HEATER': 'سخان المياه',
      'REFRIGERATOR': 'الثلاجة',
      'FRIDGE': 'الثلاجة',
      'WASHING_MACHINE': 'الغسالة',
      'WASHING MACHINE': 'الغسالة',
      'TV': 'التلفاز',
      'TELEVISION': 'التلفاز',
      'MICROWAVE': 'الميكروويف',
      'OVEN': 'الفرن',
      'DISHWASHER': 'غسالة الأطباق',
      'LIGHTS': 'الأضواء',
      'LIGHTING': 'الإضاءة',
      'FAN': 'المروحة',
      'PUMP': 'المضخة',
      'WATER_PUMP': 'مضخة المياه',
      'WATER PUMP': 'مضخة المياه',
      'HEATER': 'السخان',
      'COOLER': 'المبرد',
      'DRYER': 'المجفف',
      'LAPTOP': 'الحاسوب المحمول',
      'COMPUTER': 'الحاسوب',
      'CHARGER': 'جهاز الشحن',
      'ROUTER': 'جهاز التوجيه',
      'MODEM': 'المودم',
      'PRINTER': 'الطابعة',
      'DEVICE': 'الجهاز',

      // Room names with underscores
      'LIVING_ROOM': 'غرفة المعيشة',
      'LIVING ROOM': 'غرفة المعيشة',
      'BEDROOM': 'غرفة النوم',
      'BED_ROOM': 'غرفة النوم',
      'KITCHEN': 'المطبخ',
      'BATHROOM': 'الحمام',
      'BATH_ROOM': 'الحمام',
      'HALLWAY': 'الممر',
      'HALL_WAY': 'الممر',
      'GARAGE': 'المرآب',
      'TERRACE': 'الشرفة',
      'BALCONY': 'الشرفة',
    };

    return deviceMap[name.toUpperCase()] ?? name;
  }

  // ── Recommendation Translation ─────────────────────────────────────────────
  String translateRecommendation(String englishRecommendation) {
    const Map<String, String> recommendations = {
      'DANGER — Unsafe load detected. Disconnect high-power devices immediately!':
          'خطر — تم اكتشاف حمل غير آمن. قطع الأجهزة عالية الطاقة على الفور!',
      'WARNING — Consumption spike detected. Consider reducing load.':
          'تحذير — تم اكتشاف ارتفاع في الاستهلاك. يرجى تقليل الحمل.',
      'Monitor power consumption closely over the next hour.':
          'راقب استهلاك الطاقة عن كثب خلال الساعة القادمة.',
      'Device may be malfunctioning. Schedule maintenance check.':
          'قد يكون الجهاز معطلاً. يرجى جدولة فحص الصيانة.',
      'High energy consumption detected from this device.':
          'تم اكتشاف استهلاك طاقة عالي من هذا الجهاز.',
      'Consider unplugging devices when not in use.':
          'فكر في فصل الأجهزة عند عدم الاستخدام.',
      'No recommendation available': 'لا توجد توصيات متاحة',
    };
    return recommendations[englishRecommendation] ?? englishRecommendation;
  }
}
