import 'package:jci_app/core/PrimitiveUser/UserModel.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Task.dart';

import '../../../../../core/PrimitiveUser/User.dart';
import '../../../presentation/bloc/GetTasks/get_task_bloc.dart';
import '../TeamUser.dart';

class TaskMeta {
  final String id;
  final String name;
  final List<TeamUser> assignToMembers;
  final DateTime startDate;
  final DateTime deadline;
  final TaskCompletionStatus status;
  factory TaskMeta.empty(String? name, TaskCompletionStatus status ) {
    return TaskMeta(
      id: '',
      name: name ?? '',
      assignToMembers: [],
      startDate: DateTime.now(),
      deadline: DateTime.now(),
      status: status,
    );
  }

  TaskMeta({
    required this.id,
    required this.name,
    required this.assignToMembers,
    required this.startDate,
    required this.deadline,
    required this.status,
  });
  TaskMeta copyWith({
    String? id,
    String? name,
    List<TeamUser>? assignToImages,
    DateTime? startDate,
    DateTime? deadline,
    TaskCompletionStatus? status,
  }) {
    return TaskMeta(
      id: id ?? this.id,
      name: name ?? this.name,
      assignToMembers: assignToImages ?? assignToMembers,
      startDate: startDate ?? this.startDate,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'assignToMembers': assignToMembers.map((e) =>e.toJson()).toList(),
      'startDate': startDate.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'status': status.name,
    };
  }
  factory TaskMeta.fromJson(Map<String, dynamic> json) {
    return TaskMeta(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      assignToMembers: (json['assignToMembers'] as List<dynamic>?)
          ?.map((e) => TeamUser.fromJson(e, ))
          .toList() ?? [],

      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      deadline: DateTime.parse(json['deadline'] ?? DateTime.now().toIso8601String()),
      status: TaskCompletionStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'Todo'),
        orElse: () => TaskCompletionStatus.Todo,
      ),
    );
  }
}
