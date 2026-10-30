class AuthModel {
  final String uid;
  final String name;
  final String email;
  final String address;
  final String phoneNo;
  final String category;

  AuthModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNo,
    required this.category,
  });

  Map<String, dynamic> toMap(Object? serverTimestamp) {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "address": address,
      "phoneno": phoneNo,
      "category": category,
      "basePrice": "599",
      "isVerified": false,
      "createdAt": serverTimestamp,
    };
  }
}