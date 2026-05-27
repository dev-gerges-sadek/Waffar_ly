import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/ai_result.dart';
import 'ai_states.dart';

class AiCubit extends Cubit<AiState> {
  AiCubit() : super(AiInitial());

  final _firestore = FirebaseFirestore.instance;
  StreamSubscription? _simSub;
  StreamSubscription? _hwSub;

  void startMonitoring() {
    emit(AiLoading());

    // Current results (start with idle states)
    var simResult = AiResult.idle(source: 'simulator');
    var hwResult = AiResult.idle(source: 'hardware');

    // ── Simulator AI results listener ──────────────────────────────────────
    _simSub?.cancel();
    _simSub = _firestore.collection('ai_results').doc('simulator').snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          simResult = AiResult.fromFirestore(snapshot.data() ?? {});
        } else {
          simResult = AiResult.idle(source: 'simulator');
        }

        if (!isClosed) {
          emit(AiLoaded(simulatorResult: simResult, hardwareResult: hwResult));
        }
      },
      onError: (e) {
        if (!isClosed) emit(AiError(e.toString()));
      },
    );

    // ── Hardware AI results listener ───────────────────────────────────────
    _hwSub?.cancel();
    _hwSub = _firestore.collection('ai_results').doc('hardware').snapshots().listen(
      (snapshot) {
        if (snapshot.exists) {
          hwResult = AiResult.fromFirestore(snapshot.data() ?? {});
        } else {
          hwResult = AiResult.idle(source: 'hardware');
        }

        if (!isClosed) {
          emit(AiLoaded(simulatorResult: simResult, hardwareResult: hwResult));
        }
      },
      onError: (e) {
        if (!isClosed) emit(AiError(e.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _simSub?.cancel();
    _hwSub?.cancel();
    return super.close();
  }
}
