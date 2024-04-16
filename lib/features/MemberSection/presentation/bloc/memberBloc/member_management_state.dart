part of 'member_management_bloc.dart';
enum ActionMember {add,Remove}
enum TypeResult {Initial ,Loading,success,failed}
 class MemberManagementState extends Equatable {
  final bool isUpdated;
  final List<bool> cotisation;
  final double points;
final double clone;
final String role;
  final String ErrorMessage;
  final TypeResult typeResult;
  final List<dynamic> objectifs;


  const MemberManagementState({ this.isUpdated=false,
    this.clone=0.0,
    this.role='',
    this.objectifs=const [],


    this.cotisation=const [], this.points=0.0, this.ErrorMessage='', this.typeResult=TypeResult.Initial});
  MemberManagementState copyWith({bool? isUpdated, List<bool>? cotisation, double? points, String? ErrorMessage,
    List<dynamic>? objectifs,

    TypeResult? typeResult, double? clone, String? role}) {
    return MemberManagementState(
      objectifs: objectifs ?? this.objectifs,
      role: role ?? this.role,
      ErrorMessage: ErrorMessage ?? this.ErrorMessage,
      isUpdated: isUpdated ?? this.isUpdated,
      cotisation: cotisation ?? this.cotisation,
      typeResult: typeResult ?? this.typeResult,
      clone: clone ?? this.clone,
      points: points ?? this.points,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isUpdated, cotisation,objectifs, points, ErrorMessage, typeResult,clone,role];
}

class MemberManagementInitial extends MemberManagementState {
  @override
  List<Object> get props => [];
}
