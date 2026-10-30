import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../repository/earnings rep.dart';

class EarningsViewModel extends ChangeNotifier {
  final EarningsRepository _repository = EarningsRepository();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  String get partnerId => currentUser?.uid ?? '';

  Stream<QuerySnapshot> getEarningsStream() {
    return _repository.getEarnings();
  }

  Future<DocumentSnapshot> getUserData(String userId) async {
    return _repository.getUserData(userId);
  }

  List<QueryDocumentSnapshot> filterDocs(List<QueryDocumentSnapshot> docs) {
    if (partnerId.isNotEmpty) {
      return docs.where((doc) {
        var data = doc.data() as Map<String, dynamic>;
        String? docPartnerId = data['partnerId'] ?? data['technicianId'];
        return docPartnerId == null || docPartnerId == partnerId;
      }).toList();
    }
    return docs;
  }

  Map<String, dynamic> calculateSummary(List<QueryDocumentSnapshot> docs) {
    double thisMonthEarnings = 0.0;
    double thisWeekEarnings = 0.0;
    double todayEarnings = 0.0;
    int totalJobs = docs.length;

    DateTime now = DateTime.now();

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      double amount = double.tryParse(data['technicianEarnings']?.toString() ?? '0') ?? 0.0;
      Timestamp? timestamp = data['createdAt'] as Timestamp? ?? data['startTime'] as Timestamp?;

      if (timestamp != null) {
        DateTime jobDate = timestamp.toDate();

        if (jobDate.year == now.year && jobDate.month == now.month && jobDate.day == now.day) {
          todayEarnings += amount;
        }

        if (now.difference(jobDate).inDays <= 7) {
          thisWeekEarnings += amount;
        }

        if (jobDate.year == now.year && jobDate.month == now.month) {
          thisMonthEarnings += amount;
        }
      }
    }

    return {
      'thisMonth': thisMonthEarnings,
      'thisWeek': thisWeekEarnings,
      'today': todayEarnings,
      'totalJobs': totalJobs,
    };
  }
}