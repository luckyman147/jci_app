import 'package:json_annotation/json_annotation.dart';
part 'AuthModel.g.dart';
@JsonSerializable()
class modelAuth{
 @JsonKey(name: '_id')
 final String id;

 final String email;
 final String firstName;
 final String lastName;
 final String phone;
 final bool is_validated;
 final List<dynamic> cotisation;
 final List<dynamic> Images;


  final String role;



  factory modelAuth.fromJson(Map<String, dynamic> json) =>
      _$modelAuthFromJson(json);

  modelAuth({required this.id, required this.email, required this.firstName, required this.lastName, required this.phone, required this.is_validated, required this.cotisation, required this.Images, required this.role});

  Map<String, dynamic> toJson() => _$modelAuthToJson(this);

}