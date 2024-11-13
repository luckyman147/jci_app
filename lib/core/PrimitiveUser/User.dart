import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/Abstractions/Entity.dart';

class User extends Entity<String> {
  final String email;
  final String firstName;
  final String lastName;
  final List<dynamic> Images;

  final DocumentReference? role;

  User({super.id, super.createdAt, super.createdBy, super.lastModified, super.lastModifiedBy, required this.email, required this.firstName, required this.lastName, required this.Images, required this.role});



  @override
  List<Object?> get props => [

    id,
    createdAt,
    createdBy,
    lastModified,
    lastModifiedBy,
    email,
    firstName,
    lastName,

    Images,

    role,


  ];

  @override
  bool? get stringify => true;
}
