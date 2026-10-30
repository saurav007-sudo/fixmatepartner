import 'package:cloud_firestore/cloud_firestore.dart';

class CancelledJobsServices {
  Stream<QuerySnapshot> getCancelledJobsStream() {
    return FirebaseFirestore.instance
        .collection('jobs')
        .where('status', isEqualTo: 'rejected')
        .snapshots();
  }
}