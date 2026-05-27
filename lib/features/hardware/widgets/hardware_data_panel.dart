import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';

/// Hardware Data Panel Widget
/// Displays Firebase data for a specific device from ai_results collection
class HardwareDataPanel extends StatelessWidget {
  const HardwareDataPanel({
    super.key,
    required this.deviceId,
    required this.onDataLoaded,
  });

  final String deviceId;
  final Function(Map<String, dynamic>)? onDataLoaded;

  @override
  Widget build(BuildContext context) {
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final primary = SHColors.primary(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ai_results')
          .doc(deviceId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: primary),
          );
        }

        if (snapshot.hasError) {
          return _ErrorCard(
            message: 'Error loading Firebase data',
            color: Colors.red,
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return _EmptyCard(
            message: 'No data available for $deviceId',
            color: hintColor,
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        onDataLoaded?.call(data);

        return _DataPanel(
          deviceId: deviceId,
          data: data,
          textColor: textColor,
          hintColor: hintColor,
          primary: primary,
        );
      },
    );
  }
}

class _DataPanel extends StatelessWidget {
  const _DataPanel({
    required this.deviceId,
    required this.data,
    required this.textColor,
    required this.hintColor,
    required this.primary,
  });

  final String deviceId;
  final Map<String, dynamic> data;
  final Color textColor;
  final Color hintColor;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deviceId,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          SizedBox(height: 12.h),
          _DataRow(
            label: l10n.watts,
            value: '${(data['watts'] as num?)?.toStringAsFixed(2) ?? "N/A"} W',
            color: primary,
          ),
          SizedBox(height: 8.h),
          _DataRow(
            label: l10n.amperes,
            value: '${(data['amperes'] as num?)?.toStringAsFixed(2) ?? "N/A"} A',
            color: primary,
          ),
          SizedBox(height: 8.h),
          _DataRow(
            label: l10n.voltage,
            value: '${(data['voltage'] as num?)?.toStringAsFixed(2) ?? "N/A"} V',
            color: primary,
          ),
          SizedBox(height: 8.h),
          _DataRow(
            label: l10n.kwh,
            value: '${(data['kwh_consumed'] as num?)?.toStringAsFixed(2) ?? "N/A"} kWh',
            color: primary,
          ),
          SizedBox(height: 8.h),
          _DataRow(
            label: l10n.cost,
            value: '${(data['cost_so_far_egp'] as num?)?.toStringAsFixed(2) ?? "N/A"} EGP',
            color: Colors.green,
          ),
          SizedBox(height: 12.h),
          Divider(color: hintColor.withOpacity(0.2)),
          SizedBox(height: 8.h),
          _DataRow(
            label: l10n.decisionNormal,
            value: (data['ai_decision'] as String?) ?? 'N/A',
            color: _getDecisionColor(data['ai_decision']),
          ),
          SizedBox(height: 8.h),
          _DataRow(
            label: 'Temperature',
            value: '${(data['temperature_c'] as num?)?.toStringAsFixed(1) ?? "N/A"}°C',
            color: primary,
          ),
          SizedBox(height: 8.h),
          _DataRow(
            label: 'Humidity',
            value: '${(data['humidity_pct'] as num?)?.toStringAsFixed(1) ?? "N/A"}%',
            color: primary,
          ),
        ],
      ),
    );
  }

  Color _getDecisionColor(dynamic decision) {
    final dec = (decision as String?)?.toUpperCase() ?? '';
    if (dec.contains('CRITICAL')) return Colors.red;
    if (dec.contains('DANGER')) return Colors.orange;
    if (dec.contains('WARNING')) return Colors.amber;
    if (dec.contains('ANOMALY')) return Colors.orange;
    return Colors.green;
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: SHColors.hint(context),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: color, size: 20),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: color, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.message, required this.color});

  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: color, fontSize: 12.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
