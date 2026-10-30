class EditServiceModel {
  final String serviceName;
  final String description;
  final int basePrice;
  final String? category;

  EditServiceModel({
    required this.serviceName,
    required this.description,
    required this.basePrice,
    this.category,
  });

  factory EditServiceModel.fromMap(Map<String, dynamic>? map) {
    String category = map?['category'] ?? map?['selectedCategory'] ?? '';
    return EditServiceModel(
      serviceName: map?['serviceName'] ?? category.isNotEmpty ? category : "Electrical",
      description: map?['serviceDescription'] ?? "Repair switches, sockets and electrical faults",
      basePrice: int.tryParse(map?['basePrice']?.toString() ?? '300') ?? 300,
      category: category.isNotEmpty ? category : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceName': serviceName,
      'serviceDescription': description,
      'basePrice': basePrice,
    };
  }

  Map<String, dynamic> toDeleteMap() {
    return {
      'serviceName': null,
      'serviceDescription': null,
      'basePrice': null,
    };
  }
}