// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/sh_colors.dart';
import '../cubit/energy_cubit.dart';
import '../cubit/energy_states.dart';

class EnergyDashboardScreen extends StatelessWidget {
  const EnergyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EnergyCubit()..loadEnergy(),
      child: const _EnergyView(),
    );
  }
}

class _EnergyView extends StatelessWidget {
  const _EnergyView();

  void _showRateDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Electricity Rate', style: TextStyle(fontSize: 16.sp)),
        content: TextField(
          controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            hintText: 'Rate per kWh (e.g. 0.05)',
            suffixText: 'LE/kWh',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final rate = double.tryParse(ctrl.text);
              if (rate != null && rate > 0) {
                context.read<EnergyCubit>().updateRate(rate);
              }
              Navigator.pop(dialogCtx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    final bg        = SHColors.background(context);
    final textColor = SHColors.text(context);
    final primary   = SHColors.primary(context);
    final amber     = isDark ? SHColors.darkWarningColor : SHColors.lightWarningColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? SHColors.darkBackgroundColor : SHColors.lightBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Energy Dashboard',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: textColor)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded, color: textColor, size: 20.sp),
            onPressed: () => _showRateDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<EnergyCubit, EnergyState>(
        builder: (context, state) {
          if (state is EnergyLoading || state is EnergyInitial) {
            return Center(child: CircularProgressIndicator(color: primary));
          }
          if (state is EnergyError) {
            return Center(child: Text(state.message,
                style: TextStyle(color: SHColors.hint(context), fontSize: 13.sp)));
          }
          if (state is EnergyLoaded) {
            return _EnergyContent(state: state, amber: amber,
                onRateTap: () => _showRateDialog(context));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EnergyContent extends StatelessWidget {
  const _EnergyContent({
    required this.state, required this.amber, required this.onRateTap,
  });
  final EnergyLoaded state;
  final Color amber;
  final VoidCallback onRateTap;

  @override
  Widget build(BuildContext context) {
    final primary   = SHColors.primary(context);
    final textColor = SHColors.text(context);
    final hintColor = SHColors.hint(context);
    final green     = Colors.greenAccent.shade400;
    // Responsive: use screen width fractions instead of fixed sizes
    final sw = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(sw * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards — responsive 3-col
          Row(
            children: [
              Expanded(child: _SummaryCard(label: 'Total kWh',
                  value: state.totalKwh.toStringAsFixed(2), unit: 'kWh',
                  icon: Icons.bolt_rounded, color: primary)),
              SizedBox(width: sw * 0.025),
              Expanded(child: _SummaryCard(label: 'Est. Cost',
                  value: state.estimatedCost.toStringAsFixed(2), unit: 'LE',
                  icon: Icons.attach_money_rounded, color: amber)),
              SizedBox(width: sw * 0.025),
              Expanded(child: _SummaryCard(label: 'Devices',
                  value: '${state.records.length}', unit: 'total',
                  icon: Icons.devices_rounded, color: green)),
            ],
          ),
          SizedBox(height: 20.h),

          // Rate info
          _SectionHeader(title: 'ELECTRICITY RATE', color: hintColor),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: SHColors.card(context),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(children: [
              Icon(Icons.info_outline_rounded, color: primary, size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(child: Text(
                '${state.electricityRate.toStringAsFixed(3)} LE per kWh',
                style: TextStyle(fontSize: 13.sp, color: textColor),
                overflow: TextOverflow.ellipsis,
              )),
              TextButton(
                onPressed: onRateTap,
                child: Text('Change', style: TextStyle(fontSize: 11.sp, color: primary)),
              ),
            ]),
          ),
          SizedBox(height: 20.h),

          // Room breakdown
          _SectionHeader(title: 'BY ROOM', color: hintColor),
          SizedBox(height: 10.h),
          ...state.roomBreakdown.map((r) => _RoomBar(
              room: r, total: state.totalKwh,
              primary: primary, textColor: textColor, hintColor: hintColor)),
          SizedBox(height: 20.h),

          // Top devices
          _SectionHeader(title: 'TOP CONSUMING DEVICES', color: hintColor),
          SizedBox(height: 10.h),
          ...state.topDevices.asMap().entries.map((e) => _DeviceRankRow(
              rank: e.key + 1, deviceId: e.value.deviceId,
              kwh: e.value.kwh, watts: e.value.watts,
              primary: primary, amber: amber,
              textColor: textColor, hintColor: hintColor)),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.color});
  final String title; final Color color;
  @override
  Widget build(BuildContext context) => Text(title,
      style: TextStyle(fontSize: 10.5.sp, fontWeight: FontWeight.w700,
          color: color, letterSpacing: 1.0));
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value,
      required this.unit, required this.icon, required this.color});
  final String label, value, unit; final IconData icon; final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: color, size: 18.sp),
        SizedBox(height: 6.h),
        FittedBox(fit: BoxFit.scaleDown, child: Text(value,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: color))),
        Text(unit, style: TextStyle(fontSize: 9.sp, color: color.withOpacity(0.7))),
        SizedBox(height: 2.h),
        Text(label, style: TextStyle(fontSize: 9.sp, color: SHColors.hint(context))),
      ]),
    );
  }
}

class _RoomBar extends StatelessWidget {
  const _RoomBar({required this.room, required this.total, required this.primary,
      required this.textColor, required this.hintColor});
  final RoomEnergy room; final double total;
  final Color primary, textColor, hintColor;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? room.totalKwh / total : 0.0;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(child: Text(room.roomName,
              style: TextStyle(fontSize: 12.sp, color: textColor),
              overflow: TextOverflow.ellipsis)),
          SizedBox(width: 8.w),
          Text('${room.totalKwh.toStringAsFixed(2)} kWh · ${(pct*100).toInt()}%',
              style: TextStyle(fontSize: 10.sp, color: hintColor)),
        ]),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: pct.clamp(0.0, 1.0), minHeight: 6.h,
            backgroundColor: primary.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation(primary),
          ),
        ),
      ]),
    );
  }
}

class _DeviceRankRow extends StatelessWidget {
  const _DeviceRankRow({required this.rank, required this.deviceId,
      required this.kwh, required this.watts, required this.primary,
      required this.amber, required this.textColor, required this.hintColor});
  final int rank; final String deviceId; final double kwh, watts;
  final Color primary, amber, textColor, hintColor;

  @override
  Widget build(BuildContext context) {
    final rankColor = rank == 1 ? amber : rank == 2 ? primary : hintColor;
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(color: SHColors.card(context),
          borderRadius: BorderRadius.circular(12.r)),
      child: Row(children: [
        Container(
          width: 28.w, height: 28.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: rankColor.withOpacity(0.15), shape: BoxShape.circle),
          child: Text('#$rank', style: TextStyle(fontSize: 10.sp,
              fontWeight: FontWeight.w700, color: rankColor)),
        ),
        SizedBox(width: 10.w),
        Expanded(child: Text(deviceId.replaceAll('_', ' '),
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: textColor),
            overflow: TextOverflow.ellipsis)),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${kwh.toStringAsFixed(3)} kWh',
              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: rankColor)),
          Text('${watts.toStringAsFixed(1)} W',
              style: TextStyle(fontSize: 10.sp, color: hintColor)),
        ]),
      ]),
    );
  }
}
