import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jci_app/features/auth/domain/entities/AuthUser.dart';

class AuthUserModel extends AuthUser{
  AuthUserModel({required super.email,
    required super.id,
    required super.firstName, required super.lastName, required super.Images, required super.role, required super.language, required super.password, required super.isEmailVerified});


 // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'Images': Images,
      'role': role,
      'language': language,
      'password': password,
      'isEmailVerified': isEmailVerified,
    };}
  //from entity
  factory AuthUserModel.fromEntity(AuthUser authUser) {
    return AuthUserModel(
      id: authUser.id,
      email: authUser.email,
      firstName: authUser.firstName,
      lastName: authUser.lastName,
      Images: authUser.Images,
      role: authUser.role, language: authUser.language, password: authUser.password, isEmailVerified: authUser.isEmailVerified,) ;

  }
  //Copy with
  AuthUserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    List<dynamic>? Images,
    DocumentReference? role,
    String? language,
    String? password,
    bool? isEmailVerified,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      Images: Images ?? this.Images,
      role: role ?? this.role, language:  language ?? this.language,
      password: password ?? this.password,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,


    );
  }


    //from json
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String?,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      Images: json['Images'] as List<dynamic>,
      role: json['role'] as DocumentReference?,
        password: json['password'] as String, language: json['language'] as String, isEmailVerified: json['isEmailVerified'] as bool,

    );

  }
  // from google
  factory AuthUserModel.ofGoogle({required String email, required String displayName, required String language, required String photoUrl,required DocumentReference? role, required String id}) {
    return AuthUserModel(
      id: id,
      email: email,
      firstName: displayName.split(" ")[0],
      lastName: displayName.split(" ")[1],
      Images: [photoUrl],
      role: role, language:language,
      password: '',
      isEmailVerified: true,);}


  }
