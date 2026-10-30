import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/addnew service model.dart';
import '../services/addnew service ser.dart';


class AddNewRepository {
  final AddNewServices _services = AddNewServices();

  Future<void> createService(String partnerId, AddNewModel addNewModel) async {
    await _services.saveServiceToFirestore(partnerId, addNewModel);
  }
}