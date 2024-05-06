import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:json_annotation/json_annotation.dart';
part 'MerberLogin.g.dart';
@JsonSerializable()
class MemberLogin extends Member{
  factory MemberLogin.fromJson(Map<String, dynamic> json) =>
      _$MemberLoginFromJson(json);

  MemberLogin({required id, required role, required is_validated, required cotisation, required Images, required firstName, required lastName, required phone, required email, required password,required IsSelected,required Activities,required teams,required points,required objectif,required language}) : super(id: id,points: points,objectifs: objectif, teams: teams, Activities: Activities, IsSelected: IsSelected,role: role, is_validated: is_validated, cotisation: cotisation, Images: Images, firstName: firstName, lastName: lastName, phone: phone, email: email, password: password,language: language);

  Map<String, dynamic> toJson() => _$MemberLoginToJson(this);

}