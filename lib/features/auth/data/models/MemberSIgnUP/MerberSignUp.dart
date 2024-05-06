
import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:json_annotation/json_annotation.dart';
part 'MerberSignUp.g.dart';
@JsonSerializable()
class MemberSignup extends Member{
  factory MemberSignup.fromJson(Map<String, dynamic> json) =>
      _$MemberSignupFromJson(json);

  MemberSignup({required id, required role, required is_validated, required cotisation,required objectifs, required language,
    required Images, required firstName, required lastName, required phone, required email, required password,required IsSelected,required Activities,required teams,required points} ) : super(id: id,Activities: Activities,
language: language,
  IsSelected: IsSelected,points: points, objectifs: objectifs,
  role: role, is_validated: is_validated, cotisation: cotisation, Images: Images, firstName: firstName, lastName: lastName, phone: phone, email: email, password: password,teams: teams);

  Map<String, dynamic> toJson() => _$MemberSignupToJson(this);
}