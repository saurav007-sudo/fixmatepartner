class ActiveJobModel {
  final String id;
  final String serviceName;
  final String customerName;
  final String price;
  final String location;
  final String time;
  final String description;

  ActiveJobModel({
    required this.id,
    required this.serviceName,
    required this.customerName,
    required this.price,
    required this.location,
    required this.time,
    required this.description,
  });

  factory ActiveJobModel.fromMaps(
      Map<String, dynamic> jobData,
      Map<String, dynamic>? bookingData,
      String docId,
      ) {
    String serviceName = jobData['serviceName'] ?? 'Service';
    String customerName = jobData['customerName'] ?? 'Customer';

    String price = bookingData?['basePrice']?.toString() ??
        bookingData?['price']?.toString() ??
        jobData['basePrice'] ??
        jobData['price'] ??
        '0';

    String location = jobData['location'] ?? '';
    String time = jobData['time'] ?? 'Today';
    String description = jobData['description'] ?? 'No description provided';

    return ActiveJobModel(
      id: docId,
      serviceName: serviceName,
      customerName: customerName,
      price: price,
      location: location,
      time: time,
      description: description,
    );
  }
}