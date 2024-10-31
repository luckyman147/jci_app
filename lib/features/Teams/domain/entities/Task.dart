
import 'package:jci_app/features/Teams/data/models/CommentsModel.dart';
import 'package:jci_app/features/Teams/domain/entities/Comment.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';

import '../../data/models/CheckListModel.dart';
import '../../data/models/FileModel.dart';
import 'Checklist.dart';

class Tasks{
  final String id;
  final String name;
  final List<dynamic> AssignTo;
  final DateTime Deadline;
  final DateTime StartDate;
  final String description;
  final List<TaskFile> attachedFile;
  final List<CheckList> CheckLists;
  final bool isCompleted;
  final List<Comment>comments;


  //empty task
// tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'AssignTo': AssignTo,
      'Deadline': Deadline,
      'StartDate': StartDate,
      'description': description,
      'attachedFile': attachedFile,
      'CheckLists': CheckLists,
      'isCompleted': isCompleted,
      "comments":comments
    };
  }


  //from json
  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      comments: json['comments'] == null
          ? []
          : (json['comments'] as List<dynamic>).map((e) => CommentModel.fromJson(e as Map<String, dynamic>)).toList().cast(),
      name: json['name'] as String,
      AssignTo:   json['AssignTo'] == null ? [] : (json['AssignTo'] as List<dynamic>)
      ,

      Deadline: DateTime.parse(json['Deadline'] as String),
      attachedFile:
      json['attachedFile'] == null ? [] : (json['attachedFile'] as List<dynamic>)
          .map((e) => FileModel.fromJson(e as Map<String, dynamic>))
          .toList(),


      isCompleted: json['isCompleted'] as bool,
      id: json['id'] !=null? json['id'] as String : json['_id'] as String,


      StartDate: DateTime.parse(json['StartDate'] as String),
      description: json['description'] != null ? json['description'] as String : "",
      CheckLists: json['CheckList'] == null ? [] : (json['CheckList'] as List<dynamic>)
          .map((e) => CheckListModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }



  Tasks( {required this.id,required this.name, required this.AssignTo, required this.Deadline, required this.attachedFile, required this.CheckLists,
     required this.StartDate, required this.description
    ,required this.isCompleted,required this.comments});

}

//make to json


//make from json


