import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/addnew service model.dart';
import '../repository/addnew  service rep.dart';


class AddNewViewModel extends ChangeNotifier {
  final AddNewRepository _repository = AddNewRepository();

  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  Future<bool> createService(BuildContext context) async {
    String name = serviceNameController.text.trim();
    String priceVal = priceController.text.trim();
    String desc = descriptionController.text.trim();

    if (name.isEmpty || priceVal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in the service name and price")),
      );
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      String partnerId = FirebaseAuth.instance.currentUser?.uid ?? 'sample_partner';

      AddNewModel addNewModel = AddNewModel(
        serviceName: name,
        price: priceVal,
        description: desc,
      );

      await _repository.createService(partnerId, addNewModel);

      isLoading = false;
      notifyListeners();

      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Service created successfully!")),
      );
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create service: $e")),
      );
      return false;
    }
  }

  @override
  void dispose() {
    serviceNameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}