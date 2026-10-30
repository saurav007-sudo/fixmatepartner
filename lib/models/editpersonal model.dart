class EditProfileModel {
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String profileImage;

  EditProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.profileImage,
  });

  factory EditProfileModel.fromMap(Map<String, dynamic> map) {
    return EditProfileModel(
      name: map['name'] ?? 'Suresh Babu',
      email: map['email'] ?? 'ksaurath@gmail.com',
      phone: map['phone'] ?? '+91 6282716279',
      dob: map['dob'] ?? '08/12/2003',
      profileImage: map['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'profileImage': profileImage,
    };
  }
}