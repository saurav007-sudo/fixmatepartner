import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EarningsModel {
  final String serviceName;
  final String customerName;
  final String dateStr;
  final double amount;
  final String userId;

  EarningsModel({
    required this.serviceName,
    required this.customerName,
    required this.dateStr,
    required this.amount,
    required this.userId,
  });

  factory EarningsModel.fromMap(Map<String, dynamic> map) {
    String serviceName = map['serviceName'] ?? 'Service';
    String customerName = map['customerName'] ?? 'Customer';
    String? userId = map['userId'] ?? map['customerId'];

    Timestamp? timestamp = map['createdAt'] as Timestamp? ?? map['startTime'] as Timestamp?;
    String dateStr = "Recent";
    if (timestamp != null) {
      DateTime date = timestamp.toDate();
      dateStr = DateFormat('d MMM yyyy').format(date);
    }

    double amount = double.tryParse(map['technicianEarnings']?.toString() ?? '0') ?? 0.0;

    return EarningsModel(
      serviceName: serviceName,
      customerName: customerName,
      dateStr: dateStr,
      amount: amount,
      userId: userId ?? '',
    );
  }
}