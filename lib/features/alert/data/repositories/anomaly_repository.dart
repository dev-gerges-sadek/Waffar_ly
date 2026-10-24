import '../../../../core/data/home_scope.dart';
import '../models/anomaly_model.dart';

class AnomalyRepository {
  AnomalyRepository(this._scope);

  final HomeScope _scope;

  Stream<List<AnomalyResult>> streamAiResults() {
    return _scope
        .col('ai_results')
        .limit(50)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AnomalyResult.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }
}