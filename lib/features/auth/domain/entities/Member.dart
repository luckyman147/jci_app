import 'package:equatable/equatable.dart';
import 'package:jci_app/features/auth/presentation/widgets/inputs.dart';

import '../../../Home/domain/entities/Activity.dart';

class Member extends Equatable {
  final String id;

  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String password;
  final bool is_validated;
  final List<bool> cotisation;
  final List<String> Images;final List<String> Activities;
 final bool IsSelected;

  final String role;

  const Member(

      {
        required this.Activities,
        required this.IsSelected,
        required this.id,
        required this.role,
        required this.is_validated,
        required this.cotisation,
        required this.Images,
        required this.firstName,
        required this.lastName,
         required this.phone,
        required this.email,
        required this.password,
       });


  @override
  // TODO: implement props
  List<Object?> get props => [email, password,
    id, role, is_validated, cotisation, Images, firstName, lastName, phone,
    IsSelected, Activities

  ];}