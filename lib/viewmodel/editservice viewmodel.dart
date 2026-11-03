import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditServiceViewModel extends ChangeNotifier {
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController basePriceController = TextEditingController();

  String? partnerCategory;
  bool isLoading = false;

  String get userId => FirebaseAuth.instance.currentUser?.uid ?? 'sample_user';

  void loadServiceData({String? serviceName, String? description, String? basePrice}) {
    if (serviceName != null) serviceNameController.text = serviceName;
    if (description != null) descriptionController.text = description;
    if (basePrice != null) basePriceController.text = basePrice;
    notifyListeners();
  }

  Future<bool> saveChanges() async {
    isLoading = true;
    notifyListeners();

    try {
      double parsedPrice = double.tryParse(basePriceController.text.trim()) ?? 299.0;
      String updatedServiceName = serviceNameController.text.trim();
      String updatedDescription = descriptionController.text.trim();

      // 1. Reference and update the partner profile in Firestore
      DocumentReference partnerRef = FirebaseFirestore.instance.collection('partners').doc(userId);
      DocumentSnapshot partnerSnap = await partnerRef.get();

      await partnerRef.update({
        'serviceName': updatedServiceName,
        'description': updatedDescription,
        'workDescription': updatedDescription,
        'basePrice': parsedPrice,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 2. Extract the category/service name to target the respective category collection
      String categoryName = '';
      if (partnerSnap.exists) {
        var partnerData = partnerSnap.data() as Map<String, dynamic>?;
        categoryName = partnerData?['category'] ?? updatedServiceName;
      } else {
        categoryName = updatedServiceName;
      }

      // 3. Update the respective category collection (e.g., "AC Service", "Electrician", etc.)
      // This looks for a collection named after the category or updates documents matching this partner
      if (categoryName.isNotEmpty) {
        // Option A: If categories are structured as individual collections matching the name
        var categoryQuery = await FirebaseFirestore.instance
            .collection(categoryName) // e.g., collection('AC Service')
            .where('partnerId', isEqualTo: userId)
            .get();

        for (var doc in categoryQuery.docs) {
          await doc.reference.update({
            'basePrice': parsedPrice,
            'serviceName': updatedServiceName,
            'description': updatedDescription,
          });
        }

        // Option B: Generic 'categories' collection where category documents or sub-items exist
        var genericCategoryQuery = await FirebaseFirestore.instance
            .collection('categories')
            .where('name', isEqualTo: categoryName)
            .get();

        for (var catDoc in genericCategoryQuery.docs) {
          await catDoc.reference.update({
            'basePrice': parsedPrice,
          });
        }
      }

      // 4. Update any pending or active bookings/jobs for real-time app sync
      var pendingJobsQuery = await FirebaseFirestore.instance
          .collection('bookings')
          .where('partnerId', isEqualTo: userId)
          .where('status', whereIn: ['pending', 'upcoming', 'accepted'])
          .get();

      for (var jobDoc in pendingJobsQuery.docs) {
        await jobDoc.reference.update({
          'basePrice': parsedPrice,
          'serviceName': updatedServiceName,
          'description': updatedDescription,
        });
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error updating service and category collection: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteService() async {
    isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('partners').doc(userId).update({
        'serviceName': '',
        'description': '',
        'basePrice': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error deleting service: $e");
      isLoading = false;
      notifyListeners();
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