import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';

/// Displays a visual indicator showing data source (Simulator vs Hardware)
class AiDataSourceBadge extends StatelessWidget {
  const AiDataSourceBadge({
    required this.source,
    this.compact = false,
    super.key,
  });

  /// 'simulator' or 'hardware'
  final String source;
  
  /// If true, show only icon + short text. If false, show full badge.
  final bool compact;

  bool get isSimulator => source.toLowerCase() == 'simulator';
  bool get isHardware => source.toLowerCase() == 'hardware';

  Color _getColor(BuildContext context) {
    if (isSimulator) return Colors.orange;
    if (isHardware) return Colors.green;
    return SHColors.hint(context);
  }

  String get _label {
    if (isSimulator) return '📊 Simulator Data';
    if (isHardware) return '⚙️ Hardware Data';
    return '❓ Unknown';
  }

  String get _tooltip {
    if (isSimulator) {
      return 'This data is from the demo simulator. Not real device data.';
    }
    if (isHardware) {
      return 'This data is from real hardware devices (ESP32).';
    }
    return 'Data source is unknown.';
  }

  String get _compactLabel {
    if (isSimulator) return 'Sim';
    if (isHardware) return 'HW';
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _getColor(context).withOpacity(0.1);
    final textColor = _getColor(context);

    if (compact) {
      return Tooltip(
        message: _tooltip,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: textColor, width: 0.5),
          ),
          child: Text(
            _compactLabel,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      );
    }

    return Tooltip(
      message: _tooltip,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: textColor, width: 0.5),
        ),
        child: Text(
          _label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
