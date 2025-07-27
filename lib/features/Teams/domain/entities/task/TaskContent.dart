import '../Checklist.dart';
import '../TaskFile.dart';

class TaskContent {
  final String description;
  final List<TaskFile> attachedFiles;
  final List<CheckList> checkLists;

  factory TaskContent.empty() {
    return TaskContent(
      description: '',
      attachedFiles: [],
      checkLists: [],
    );
  }
  TaskContent({
    required this.description,
    required this.attachedFiles,
    required this.checkLists,
  });
  TaskContent copyWith({
    String? description,
    List<TaskFile>? attachedFiles,
    List<CheckList>? checkLists,
  }) {
    return TaskContent(
      description: description ?? this.description,
      attachedFiles: attachedFiles ?? this.attachedFiles,
      checkLists: checkLists ?? this.checkLists,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'attachedFiles': attachedFiles.map((e) => e.toJson()).toList(),
      'checkLists': checkLists.map((e) => e.toJson()).toList(),
    };
  }
  factory TaskContent.fromJson(Map<String, dynamic> json) {
    return TaskContent(
      description: json['description'] ?? '',
      attachedFiles: (json['attachedFiles'] as List)
          .map((e) => TaskFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      checkLists: (json['checkLists'] as List)
          .map((e) => CheckList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
