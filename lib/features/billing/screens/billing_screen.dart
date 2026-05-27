import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/sh_colors.dart';
import '../cubit/billing_cubit.dart';
import '../cubit/billing_states.dart';
import '../widgets/billing_cost_card.dart';
import '../widgets/daily_chart.dart';
import '../widgets/monthly_chart.dart';
import '../widgets/weekly_chart.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BillingCubit()..loadBilling(),
      child: _BillingView(tabController: _tabController),
    );
  }
}

class _BillingView extends StatelessWidget {
  const _BillingView({required this.tabController});
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = SHColors.background(context);
    final textColor = SHColors.text(context);
    final primary = SHColors.primary(context);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark
            ? SHColors.darkBackgroundColor
            : SHColors.lightBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: textColor, size: 18.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.billing,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BillingCubit, BillingState>(
        builder: (context, state) {
          if (state is BillingLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primary),
                  SizedBox(height: 12.h),
                  Text(
                    'Loading billing data…',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: SHColors.hint(context),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is BillingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 48.sp,
                    color: Colors.red.withOpacity(0.6),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: SHColors.hint(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is BillingLoaded) {
            return Column(
              children: [
                // ── Key metrics cards ──────────────────────────────────
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      BillingCostCard(
                        label: l10n.monthlyCost,
                        value: state.currentMonthCost.toStringAsFixed(2),
                        unit: 'EGP',
                        icon: '📊',
                        color: Colors.green,
                      ),
                      SizedBox(width: 10.w),
                      BillingCostCard(
                        label: l10n.estimatedNextBill,
                        value: state.estimatedNextBill.toStringAsFixed(2),
                        unit: 'EGP',
                        icon: '📈',
                        color: Colors.blue,
                      ),
                      SizedBox(width: 10.w),
                      BillingCostCard(
                        label: l10n.peakUsage,
                        value: state.peakUsageDay,
                        unit: '',
                        icon: '⚡',
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),

                // ── Tab bar ────────────────────────────────────────────
                Material(
                  color: SHColors.card(context),
                  child: TabBar(
                    controller: tabController,
                    labelColor: primary,
                    unselectedLabelColor: SHColors.hint(context),
                    indicatorColor: primary,
                    tabs: [
                      Tab(text: l10n.dailyCost),
                      Tab(text: l10n.weeklyCost),
                      Tab(text: l10n.monthlyCost),
                    ],
                  ),
                ),

                // ── Tab content ───────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      // Daily tab
                      DailyChartWidget(dailyData: state.dailyData),
                      // Weekly tab
                      WeeklyChartWidget(weeklyData: state.weeklyData),
                      // Monthly tab
                      MonthlyChartWidget(monthlyData: state.monthlyData),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
