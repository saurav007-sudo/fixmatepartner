class HomeModel {
  final String partnerName;
  final String category;
  final bool isVerified;
  final bool isSubmitted;

  HomeModel({
    required this.partnerName,
    required this.category,
    required this.isVerified,
    required this.isSubmitted,
  });

  factory HomeModel.fromPartnerMap(Map<String, dynamic>? map) {
    return HomeModel(
      partnerName: map?['name'] ?? '',
      category: map?['category'] ?? '',
      isVerified: map?['isVerified'] ?? false,
      isSubmitted: map?['idSubmitted'] ?? false,
    );
  }
}

class JobRequestModel {
  final String id;
  final String serviceName;
  final String customerName;
  final String location;
  final String estimatedPrice;
  final String? userId;

  JobRequestModel({
    required this.id,
    required this.serviceName,
    required this.customerName,
    required this.location,
    required this.estimatedPrice,
    this.userId,
  });

  factory JobRequestModel.fromMap(Map<String, dynamic> map, String docId) {
    return JobRequestModel(
      id: docId,
      serviceName: map['serviceName'] ?? map['category'] ?? '',
      customerName: map['customerName'] ?? 'Customer',
      location: map['location'] ?? '',
      estimatedPrice: map['basePrice']?.toString() ?? map['price']?.toString() ?? '0',
      userId: map['userId'] ?? map['customerId'],
    );
  }
}