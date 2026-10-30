import 'package:flutter/cupertino.dart';

class ProfileModel {
  final String partnerName;
  final String category;
  final String expYears;
  final String? profileImageUrl;

  ProfileModel({
    required this.partnerName,
    required this.category,
    required this.expYears,
    this.profileImageUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic>? map) {
    return ProfileModel(
      partnerName: map?['name'] ?? "Arun Kumar",
      category: map?['selectedCategory'] ?? map?['category'] ?? "Electrician",
      expYears: map?['yearsOfExperience'] ?? "7+",
      profileImageUrl: map?['profileImage'],
    );
  }
}