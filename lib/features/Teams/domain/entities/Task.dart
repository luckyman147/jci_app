import 'package:flutter/material.dart';

import 'Checklist.dart';

class Tasks{
  final String id;
  final String name;
  final List<dynamic> AssignTo;
  final DateTime Deadline;
  final DateTime StartDate;
  final String description;
  final List<String> attachedFile;
  final List<CheckList> CheckLists;
  final bool isCompleted;

  Tasks( {required this.id,required this.name, required this.AssignTo, required this.Deadline, required this.attachedFile, required this.CheckLists,
     required this.StartDate, required this.description
    ,required this.isCompleted});

}