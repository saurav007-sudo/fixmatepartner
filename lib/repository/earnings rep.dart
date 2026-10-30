import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/earnings ser.dart';

class EarningsRepository {
  final EarningsServices _services = EarningsServices();

  Stream<QuerySnapshot> getEarnings() {
    return _services.getEarningsStream();
  }

  Future<DocumentSnapshot> getUserData(String userId) async {
    return _services.getUserDocument(userId);
  }
}