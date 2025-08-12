import 'package:jci_app/core/app_theme.dart';

import '../../domain/entities/task/Task.dart';
import 'package:flutter/material.dart';

class TeamConstants{
  static final Map<TaskCompletionStatus, Color> taskStatusColors = {
    TaskCompletionStatus.Todo: ColorsApp.PrimaryColor,
    TaskCompletionStatus.InProgress: Colors.orange,
    TaskCompletionStatus.Completed: Colors.green,
    TaskCompletionStatus.Delayed: Colors.red,
  };
}