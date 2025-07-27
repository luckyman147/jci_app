import 'package:jci_app/features/Teams/domain/entities/task/Task.dart';

import '../../../presentation/bloc/GetTasks/get_task_bloc.dart';

class TaskMeta {
  final String id;
  final String name;
  final List<String> assignToImages;
  final DateTime startDate;
  final DateTime deadline;
  final TaskCompletionStatus status;
  factory TaskMeta.empty(String? name) {
    return TaskMeta(
      id: '',
      name: name ?? '',
      assignToImages: [],
      startDate: DateTime.now(),
      deadline: DateTime.now(),
      status: TaskCompletionStatus.Todo,
    );
  }

  TaskMeta({
    required this.id,
    required this.name,
    required this.assignToImages,
    required this.startDate,
    required this.deadline,
    required this.status,
  });
  TaskMeta copyWith({
    String? id,
    String? name,
    List<String>? assignToImages,
    DateTime? startDate,
    DateTime? deadline,
    TaskCompletionStatus? status,
  }) {
    return TaskMeta(
      id: id ?? this.id,
      name: name ?? this.name,
      assignToImages: assignToImages ?? this.assignToImages,
      startDate: startDate ?? this.startDate,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'assignToImages': assignToImages,
      'startDate': startDate.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'status': status.name,
    };
  }
  factory TaskMeta.fromJson(Map<String, dynamic> json) {
    return TaskMeta(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      assignToImages: List<String>.from(json['assignToImages'] ?? []),
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      deadline: DateTime.parse(json['deadline'] ?? DateTime.now().toIso8601String()),
      status: TaskCompletionStatus.values.firstWhere(
        (e) => e.name == (json['status'] ?? 'Todo'),
        orElse: () => TaskCompletionStatus.Todo,
      ),
    );
  }
}
