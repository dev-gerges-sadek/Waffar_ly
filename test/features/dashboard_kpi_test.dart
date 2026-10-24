import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:waffar_ly_app/core/l10n/app_localizations.dart';
import 'package:waffar_ly_app/features/ai_dashboard/cubit/ai_energy_state.dart';
import 'package:waffar_ly_app/features/ai_dashboard/models/ai_result.dart';
import 'package:waffar_ly_app/features/ai_dashboard/widgets/kpi_grid.dart';

AiEnergyLoaded _state() => AiEnergyLoaded(
  simulator: AiResult.idle('simulator'),
  hardware: AiResult.idle('hardware'),
  records: const [],
  totalKwh: 12.5,
  estimatedCost: 15.63,
  topDevices: const [],
  roomBreakdown: const [],
  electricityRate: 1.25,
  systemHealth: SystemHealthStatus.healthy,
  lastRefreshed: DateTime(2026, 1, 1),
);

Widget _app(Locale locale, {double textScale = 1.0, double width = 390}) =>
    MediaQuery(
      data: MediaQueryData(
        size: Size(width, 844),
        textScaler: TextScaler.linear(textScale),
      ),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => MaterialApp(
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: DashboardKpiGrid(state: _state()),
            ),
          ),
        ),
      ),
    );

void main() {
  testWidgets('renders in English with all four tiles', (tester) async {
    await tester.pumpWidget(_app(const Locale('en')));
    await tester.pumpAndSettle();
    expect(find.text('Live power'), findsOneWidget);
    expect(find.text('Energy used'), findsOneWidget);
    expect(find.text('Estimated cost'), findsOneWidget);
    expect(find.text('Active devices'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders in Arabic (RTL) without overflow at 1.8x text', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const Locale('ar'), textScale: 1.8));
    await tester.pumpAndSettle();
    expect(find.text('القدرة الحالية'), findsOneWidget);
    expect(find.text('الأجهزة النشطة'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses four columns on wide screens', (tester) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app(const Locale('en'), width: 900));
    await tester.pumpAndSettle();
    final tops = tester
        .widgetList<SizedBox>(find.byType(SizedBox))
        .where((s) => s.width != null && s.width! > 100 && s.width! < 300)
        .length;
    expect(tops, greaterThanOrEqualTo(4));
    expect(tester.takeException(), isNull);
  });
}
