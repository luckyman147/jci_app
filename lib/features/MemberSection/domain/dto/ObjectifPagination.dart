import 'package:cloud_firestore/cloud_firestore.dart';

class ObjectifPaginationDto{
  final String userId;
  final int limit;
  final DocumentSnapshot? lastDocument;

  ObjectifPaginationDto({required this.userId,  this.limit=10, required this.lastDocument});


}