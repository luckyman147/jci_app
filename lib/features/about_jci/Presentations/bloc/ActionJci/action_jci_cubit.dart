import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

part 'action_jci_state.dart';

class ActionJciCubit extends Cubit<ActionJciState> {
  ActionJciCubit() : super(ActionJciInitial());
  void changeAction(PresidentsAction action){
    emit(state.copyWith(action: action));
  }
  void changeYear(String year){
    emit(state.copyWith(year: year));
  }
  void changeCloneYear(String cloneYear){
    emit(state.copyWith(cloneYear: cloneYear));
  }
  void changeMember(Member member){
    Map<String, dynamic> updatedNewMember = Map.from(state.member);

    // Update the value associated with the specific key
    updatedNewMember['member'] =member;

    // Create a new state with updated newRole
    ActionJciState newState = state.copyWith(member: updatedNewMember,);

    // Emit the new state
    emit(newState);
  } void RemoveMember(){
    Map<String, dynamic> updatedNewMember = Map.from(state.member);

    // Update the value associated with the specific key
    updatedNewMember['member'] =null;

    // Create a new state with updated newRole
    ActionJciState newState = state.copyWith(member: updatedNewMember,);

    // Emit the new state
    emit(newState);
  }
  void changePageNum(int pageNum){
    emit(state.copyWith(pageNum: pageNum));
  }
}
