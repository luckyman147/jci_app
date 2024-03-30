import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:json_annotation/json_annotation.dart';
part 'FileModel.g.dart';
@JsonSerializable()

class FileModel extends TaskFile{
  FileModel({required super.url, required super.path, required super.extension, required super.id});
  factory FileModel.fromJson(Map<String, dynamic> json) => _$FileModelFromJson(json);
  Map<String, dynamic> toJson() => _$FileModelToJson(this);
  factory FileModel.fromEntity(TaskFile taskFile) {
    return FileModel(
      id: taskFile.id,
      url: taskFile.url,
      path: taskFile.path,
      extension: taskFile.extension,
    );
  }

}