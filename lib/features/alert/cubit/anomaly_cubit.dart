import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/anomaly_repository.dart';
import 'anomaly_states.dart';

class AnomalyCubit extends Cubit<AnomalyState> {
  AnomalyCubit(this._repository) : super(AnomalyInitial());

  final AnomalyRepository _repository;
  StreamSubscription? _sub;

  void startMonitoring() {
    emit(AnomalyLoading());
    _sub?.cancel();

    _sub = _repository.streamAiResults().listen(
      (results) {
        final alerts =
            results
                .where((r) => r.isAnomaly)
                .map(
                  (r) => AnomalyAlert(
                    deviceId: r.id,
                    currentKwh: r.kwhConsumed,
                    watts: r.watts,
                    probAnomaly: r.probAnomalyPct,
                    aiDecision: r.aiDecision,
                    recommendation: r.recommendation,
                    detectedAt: DateTime.now(),
                  ),
                )
                .toList()
              ..sort((a, b) => b.probAnomaly.compareTo(a.probAnomaly));

        if (!isClosed) {
          emit(AnomalyLoaded(alerts: alerts, allClear: alerts.isEmpty));
        }
      },
      onError: (e) {
        if (!isClosed) emit(AnomalyError(e.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
