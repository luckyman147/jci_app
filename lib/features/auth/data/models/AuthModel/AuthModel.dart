import 'package:json_annotation/json_annotation.dart';
part 'AuthModel.g.dart';
@JsonSerializable()
class modelAuth{

  final String email;

  final String role;

  modelAuth({required this.email, required this.role});

  factory modelAuth.fromJson(Map<String, dynamic> json) =>
      _$modelAuthFromJson(json);

  Map<String, dynamic> toJson() => _$modelAuthToJson(this);

}