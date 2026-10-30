class AddNewModel {
  final String serviceName;
  final String price;
  final String description;

  AddNewModel({
    required this.serviceName,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toServiceMap(String partnerId, Object? serverTimestamp) {
    return {
      'partnerId': partnerId,
      'serviceName': serviceName,
      'price': price,
      'basePrice': price,
      'description': description.isNotEmpty ? description : 'No description provided',
      'createdAt': serverTimestamp,
    };
  }

  Map<String, dynamic> toPartnerMap() {
    return {
      'serviceName': serviceName,
      'basePrice': price,
      'serviceDescription': description,
    };
  }
}