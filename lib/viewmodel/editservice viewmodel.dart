import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/editservice model.dart';
import '../repository/editservice rep.dart';


class EditServiceViewModel extends ChangeNotifier {
  final EditServiceRepository _repository = EditServiceRepository();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController basePriceController = TextEditingController();

  String? partnerCategory;
  bool isLoading = false;

  Future<void> loadServiceData() async {
    String uid = currentUser?.uid ?? 'sample_partner';
    EditServiceModel? service = await _repository.getServiceData(uid);

    if (service != null) {
      partnerCategory = service.category;
      serviceNameController.text = service.serviceName;
      descriptionController.text = service.description;
      basePriceController.text = service.basePrice.toString();
      notifyListeners();
    }
  }

  Future<bool> saveChanges() async {
    isLoading = true;
    notifyListeners();

    try {
      String uid = currentUser?.uid ?? 'sample_partner';
      int parsedPrice = int.tryParse(basePriceController.text.trim()) ?? 300;

      EditServiceModel serviceModel = EditServiceModel(
        serviceName: serviceNameController.text.trim(),
        description: descriptionController.text.trim(),
        basePrice: parsedPrice,
        category: partnerCategory,
      );

      await _repository.updateService(uid, serviceModel);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Error: $e");
      return false;
    }
  }

  Future<bool> deleteService() async {
    isLoading = true;
    notifyListeners();

    try {
      String uid = currentUser?.uid ?? 'sample_partner';
      await _repository.deleteService(uid, partnerCategory);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint("Error: $e");
      return false;
    }
  }

  @override
  void dispose() {
    serviceNameController.dispose();
    descriptionController.dispose();
    basePriceController.dispose();
    super.dispose();
  }
}