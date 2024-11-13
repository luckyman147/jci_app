import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class UserModel extends User{
  UserModel({required super.email, required super.firstName, required super.lastName, required super.Images, required super.role});
  // toJson
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'Images': Images,
      'role': role,
    };
  }
  // fromJson
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      Images: json['Images'] as List<dynamic>,
      role: json['role'] as DocumentReference?,
    );
  }

}