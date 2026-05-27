import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waffar_ly_app/features/alert/cubit/anomaly_states.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/locale_cubit.dart';
import '../../../core/theme/sh_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../cubit/anomaly_cubit.dart';
import '../widgets/widgets.dart';
import '../data/repositories/anomaly_repository.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (_, _) {
        return BlocProvider(
          create: (_) => AnomalyCubit(AnomalyRepository())..startMonitoring(),
          child: const _AnomalyView(),
        );
      },
    );
  }
}

class _AnomalyView extends StatelessWidget {
  const _AnomalyView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: SHColors.background(context),
      appBar: ShBackAppBar(
        title: l10n.anomalyAlertsTitle,
        trailing: LiveIndicatorBadge(label: l10n.monitoringLabel),
      ),
      body: BlocBuilder<AnomalyCubit, AnomalyState>(
        builder: (context, state) {
          if (state is AnomalyLoading || state is AnomalyInitial) {
            return LoadingView(message: l10n.connectingFirebase);
          }
          if (state is AnomalyError) {
            return ErrorView(message: state.message);
          }
          if (state is AnomalyLoaded) {
            if (state.allClear) return const AllClearView();
            return _AlertsList(alerts: state.alerts);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _AlertsList extends StatelessWidget {
  const _AlertsList({required this.alerts});
  final List<AnomalyAlert> alerts;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        const AlertsInfoBanner(),
        SizedBox(height: 12.h),
        ...alerts.map(
          (a) => Padding(
            padding: EdgeInsetsDirectional.only(bottom: 10.h),
            child: AlertCard(alert: a),
          ),
        ),
      ],
    );
  }
}
