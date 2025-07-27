import 'dart:developer';

import 'package:jci_app/core/MemberModel.dart';

import '../../../../core/Member.dart';
import '../../Domain/entities/Post.dart';

class PostModel extends Post{
  PostModel({required super.id, required super.boardRoleId, required super.role, required super.assignTo});
  factory PostModel.fromJson(Map<String, dynamic> json) {
    log(( json['Assignto'] == []  || json['Assignto'] == null).toString());
    return PostModel(
      id: json['_id'],
      boardRoleId: json['BoardRole_id'],
      role: json['role'],
      assignTo:
      json['Assignto'] == [null]  || json['Assignto'] == null ? [] :
      (json['Assignto'] as List)
          .map((assignTo) => Member.fromImages(assignTo))
          .toList(),
    );
  }
  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      boardRoleId: post.boardRoleId,
      role: post.role,
      assignTo: post.assignTo,
    );
  }
Map<String,dynamic> toJson()=>




    {
      '_id': id,
      'BoardRole_id': boardRoleId,
      'role': role,
      'Assignto': assignTo.map((assignTo) => MemberModel.fromEntity(assignTo).toJson()).toList(),








    };

}