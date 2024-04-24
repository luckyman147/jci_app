import 'dart:developer';

import '../../Domain/entities/BoardYear.dart';
import 'PostModel.dart';

class BoardYearModel extends BoardYear{
  BoardYearModel({required super.year, required super.posts});
  factory BoardYearModel.fromJson(Map<String, dynamic> json) {

    return BoardYearModel(
      year: json['_id'],
      posts: (json['boards']['Posts'] as List)
          .map((priorityList) => (priorityList as List)
          .map((post) => PostModel.fromJson(post))
          .toList())
          .toList(),
    );
  }
  Map<String,dynamic> toJson() {
    return {
      "_id":year ,
      'boards': {
  'Posts': posts.map((priorityList) => priorityList.map((post) =>PostModel.fromEntity(post).toJson() ).toList()).toList(),
  },
  };
}
}