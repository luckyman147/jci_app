import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:json_annotation/json_annotation.dart';
part 'AuthModel.g.dart';
@JsonSerializable()
class MemberModel extends Member{




  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      MemberModel(
        id: json['_id']!=null ? json['_id']as String : json['id'] as String,
        role: json['role'] != null ? json['role'] as String : "member" ,
        is_validated: json['is_validated'] ?? false,
        cotisation:
        json['cotisation'] == null ? [false, ] :
        (json['cotisation'] as List<dynamic>).map((e) => e as bool).toList(),
        Images:
        (json['Images'] as List<dynamic>).map((e) => e as String).toList(),
        firstName: json['firstName'] as String,
        lastName: json['lastName']?? '' ,
        phone: json['phone'] ??"",
        email: json['email'] as String,
        password: "",
        IsSelected:false,
        Activities:
        json['Activities'] == null ? [] :

        (json['Activities'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      );
  MemberModel({required super.id, required super.role, required super.is_validated, required super.cotisation, required super.Images, required super.firstName, required super.lastName, required super.phone, required super.email, required super.password, required super.IsSelected, required super.Activities});

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);

}