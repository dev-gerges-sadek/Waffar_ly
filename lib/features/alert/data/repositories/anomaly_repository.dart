import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/anomaly_model.dart';

class AnomalyRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<List<AnomalyResult>> streamAiResults() {
    return _firestore
        .collection('ai_results')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return AnomalyResult.fromFirestore(doc.id, doc.data());
      }).toList();
    });
  }
}