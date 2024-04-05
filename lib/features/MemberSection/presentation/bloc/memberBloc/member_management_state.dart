part of 'member_management_bloc.dart';

abstract class MemberManagementState extends Equatable {
  const MemberManagementState();
}

class MemberManagementInitial extends MemberManagementState {
  @override
  List<Object> get props => [];
}
