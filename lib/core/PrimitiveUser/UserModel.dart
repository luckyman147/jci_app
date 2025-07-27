import 'package:cloud_firestore/cloud_firestore.dart';

import 'User.dart';

class UserModel extends User{
  UserModel({required super.email,
    required super.id,

    required super.firstName, required super.lastName, required super.Images, required super.role});
  // toJson
  Map<String, dynamic> toJson(bool toencode) {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'Images': Images,
      'role': toencode?role!=null? role!.path:"/roles/ThBSWmwP5TJieuS6Pfo1" :role,
    };
  }
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      Images: user.Images,
      role: user.role,
    );
  }
  // fromJson
  factory UserModel.fromJson(Map<String, dynamic> json,bool todecode) {
    return UserModel(
      id: json['id'] as String?,

      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      Images:  json ["Images"]!=null?    json['Images'] as List<dynamic>:[],
      role: json['role'] != null
          ? (json['role'] is String
          ? FirebaseFirestore.instance.doc(json['role'] as String)
          : json['role'] as DocumentReference)
          : null,    );
  } factory UserModel.fromObject(Map<Object?, Object?> json,bool todecode) {
    return UserModel(
      id: json['id'] as String?,

      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      Images: json ["Images"]!=null?    json['Images'] as List<dynamic>:[],
      role: json['role'] != null
          ? (json['role'] is String
          ? FirebaseFirestore.instance.doc(json['role'] as String)
          : json['role'] as DocumentReference)
          : null,    );
  }

}