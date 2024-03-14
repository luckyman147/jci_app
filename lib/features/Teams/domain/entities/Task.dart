import 'package:flutter/material.dart';

import 'Checklist.dart';

class Tasks{
  final String id;
  final String name;
  final String AssignTo;
  final DateTime Deadline;
  final List<String> attachedFile;
  final List<String> checkList;
  final bool isCompleted;

  Tasks({required this.id,required this.name, required this.AssignTo, required this.Deadline, required this.attachedFile, required this.checkList, required this.isCompleted});

}