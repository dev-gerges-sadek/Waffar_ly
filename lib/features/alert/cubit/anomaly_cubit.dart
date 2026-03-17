import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import 'anomaly_states.dart';

class AnomalyCubit extends Cubit<AnomalyState> {
  AnomalyCubit() : super(AnomalyInitial());

  final _firestore = FirebaseFirestore.instance;
  StreamSubscription? _sub;

  // In-memory history per device: deviceId → list of past kWh readings
  final Map<String, List<double>> _history = {};

  void startMonitoring() {
    emit(AnomalyLoading());

    _sub?.cancel();
    _sub = _firestore
        .collection(AppConstants.colDeviceStates)
        .snapshots()
        .listen((snap) {
      final alerts = <AnomalyAlert>[];

      for (final doc in snap.docs) {
        final kwh = (doc.data()['kwh'] as num?)?.toDouble();
        if (kwh == null || kwh == 0) continue;

        final id = doc.id;

        // Accumulate history (keep last 20 readings)
        _history.putIfAbsent(id, () => []);
        _history[id]!.add(kwh);
        if (_history[id]!.length > 20) {
          _history[id]!.removeAt(0);
        }

        // Need at least minDataPoints before we can detect anomalies
        if (_history[id]!.length < AppConstants.anomalyMinDataPoints) continue;

        final zScore = _calcZScore(_history[id]!, kwh);

        if (zScore.abs() > AppConstants.anomalyZScoreThreshold) {
          final avg = _mean(_history[id]!);
          alerts.add(AnomalyAlert(
            deviceId:   id,
            currentKwh: kwh,
            avgKwh:     avg,
            zScore:     zScore,
            severity:   _severity(zScore),
            detectedAt: DateTime.now(),
          ));
        }
      }

      // Sort: highest z-score first
      alerts.sort((a, b) => b.zScore.abs().compareTo(a.zScore.abs()));

      if (!isClosed) {
        emit(AnomalyLoaded(alerts: alerts, allClear: alerts.isEmpty));
      }
    }, onError: (e) => emit(AnomalyError(e.toString())));
  }

  // ── Statistics helpers ────────────────────────────────────────────────────

  double _mean(List<double> data) =>
      data.reduce((a, b) => a + b) / data.length;

  double _stdDev(List<double> data) {
    final avg = _mean(data);
    final variance =
        data.map((x) => pow(x - avg, 2)).reduce((a, b) => a + b) / data.length;
    return sqrt(variance);
  }

  double _calcZScore(List<double> history, double current) {
    final std = _stdDev(history);
    if (std == 0) return 0;
    return (current - _mean(history)) / std;
  }

  AnomalySeverity _severity(double zScore) {
    final abs = zScore.abs();
    if (abs >= 4.0) return AnomalySeverity.high;
    if (abs >= 3.0) return AnomalySeverity.medium;
    return AnomalySeverity.low;
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
