import 'package:cloud_firestore/cloud_firestore.dart';

class EarningsServices {
  Stream<QuerySnapshot> getEarningsStream() {
    return FirebaseFirestore.instance
        .collection('jobs')
        .where('status', whereIn: ['completed', 'closed'])
        .snapshots();
  }

  Future<DocumentSnapshot> getUserDocument(String userId) async {
    return await FirebaseFirestore.instance.collection('users').doc(userId).get();
  }
}