class CancelledJobModel {
  final String id;
  final String serviceName;
  final String customerName;
  final String price;
  final String location;
  final String time;
  final String description;

  CancelledJobModel({
    required this.id,
    required this.serviceName,
    required this.customerName,
    required this.price,
    required this.location,
    required this.time,
    required this.description,
  });

  factory CancelledJobModel.fromMap(Map<String, dynamic> map, String docId) {
    return CancelledJobModel(
      id: docId,
      serviceName: map['serviceName'] ?? 'Service',
      customerName: map['customerName'] ?? 'Customer',
      price: map['price']?.toString() ?? '0',
      location: map['location'] ?? '',
      time: map['time'] ?? 'Today',
      description: map['description'] ?? 'No description provided',
    );
  }
}