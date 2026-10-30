class ServicesPricingModel {
  final String partnerName;
  final String serviceName;
  final String serviceDescription;
  final String basePrice;
  final String? profileImageUrl;

  ServicesPricingModel({
    required this.partnerName,
    required this.serviceName,
    required this.serviceDescription,
    required this.basePrice,
    this.profileImageUrl,
  });

  factory ServicesPricingModel.fromMap(Map<String, dynamic>? map) {
    return ServicesPricingModel(
      partnerName: map?['name'] ?? "Suresh Babu",
      serviceName: map?['serviceName'] ?? map?['selectedCategory'] ?? "Electrical",
      serviceDescription: map?['serviceDescription'] ?? "Repair switches, sockets and electrical faults",
      basePrice: map?['basePrice']?.toString() ?? "299",
      profileImageUrl: map?['profileImage'],
    );
  }
}