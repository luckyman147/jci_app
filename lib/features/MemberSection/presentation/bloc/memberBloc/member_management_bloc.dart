import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/MemberRepo.dart';

import '../../../../../core/error/Failure.dart';
import '../../../domain/usecases/MemberUseCases.dart';

part 'member_management_event.dart';
part 'member_management_state.dart';

class MemberManagementBloc extends Bloc<MemberManagementEvent, MemberManagementState> {
  final UpdateCotisationUseCase updateCotisationUseCase;
  final UpdatePointsUseCase updatePointsUseCase;
  final validateMemberuseCase validateMemberUseCase;
  final ChangeRoleUseCase changeRoleUseCase;
  final SendInactivityReportUseCase sendInactivityReportUseCase;
  final SendMembershipReportUseCase sendMembershipReportUseCase;
final ChangeLanguageUseCase changeLanguageUseCase;
  MemberManagementBloc(this.updateCotisationUseCase, this.updatePointsUseCase, this.validateMemberUseCase, this.changeRoleUseCase, this.changeLanguageUseCase, this.sendInactivityReportUseCase, this.sendMembershipReportUseCase) : super(MemberManagementInitial()) {
    on<MemberManagementEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<initMemberEvent>(initMember);
    on<UpdateCotisation>(updateCotisation);
    on<UpdatePoints>(updatePoints);
    on<validateMember>(_validateMember);
    on<AddPoints>(_addPoints);
    on<RemovePoints>(_RemovePoints);
    on<AddCotisation>(_addCotisatisation);
    on<ChangeRoleEvent>(_changeRole);
    on<ChangeLanguageEvent>(_changeLanguage);
    on<SendInactivityReportEvent>(_sendInactivityReport);
    on<SendMembershipReportEvent>(_sendMembershipReport);
  }
  void initMember(initMemberEvent event, Emitter<MemberManagementState> emit) {
    emit(MemberManagementState(isUpdated: event.isUpdated, cotisation: event.cotisation, points: event.points,
        role: event.role, clone: event.points,objectifs: event.objectifs));

  }

  void _sendInactivityReport(SendInactivityReportEvent event,Emitter<MemberManagementState> emit) async {
    final result =await  sendInactivityReportUseCase(event.id);
    emit(_eitherSendInactivityReportOrFailute(result, 'Inactivity Report Sent Successfully'));
  }
  void _sendMembershipReport(SendMembershipReportEvent event,Emitter<MemberManagementState> emit) async {
    final result =await  sendMembershipReportUseCase(event.id);
    emit(_eitherSendInactivityReportOrFailute(result, 'Membership Report Sent Successfully'));
  }














  void _addPoints(AddPoints event,Emitter<MemberManagementState> emit) async {
   emit(state.copyWith(clone: state.clone+50));
  }
  void _RemovePoints(RemovePoints event,Emitter<MemberManagementState> emit) async {
    if (state.clone -50 >= 0){
   emit(state.copyWith(clone: state.clone-50));}
  }
void _addCotisatisation(AddCotisation event,Emitter<MemberManagementState> emit) async {
  state.cotisation.add(false);
    emit(state.copyWith(cotisation:state.cotisation ));
  }
  void _changeLanguage(ChangeLanguageEvent event,Emitter<MemberManagementState> emit) async {
    final result =await  changeLanguageUseCase(event.language);
    emit(_eitherChangeLanguageOrFailute(result, 'Language Changed Successfully', event.language));
  }





  void _changeRole(ChangeRoleEvent event,Emitter<MemberManagementState> emit) async {
    try{
      final result =await  changeRoleUseCase(event.changeRoleParams);
      emit(_eitherChangeToAdminOrFailute(result, 'User Updated Successfully',  event.changeRoleParams.type,));
    }
    catch(e){
      emit(state.copyWith(typeResult: TypeResult.failed, ErrorMessage: e.toString()));
    }
  }

  void updateCotisation(UpdateCotisation event, Emitter<MemberManagementState> emit) async {
    try{
      final result =await  updateCotisationUseCase(event.updateCotisationParams);
   emit(_eitherCotisationOrFailute(result, 'Cotisation Updated Successfully',event.updateCotisationParams.type,event.updateCotisationParams.cotisation, ));

    }
    catch(e){
      emit(state.copyWith(typeResult: TypeResult.failed, ErrorMessage: e.toString()));
    }



  }


  void updatePoints(UpdatePoints event, Emitter<MemberManagementState> emit) async {
    try{
      final result =await  updatePointsUseCase(event.updatePointsParams);
      emit(_eitherUpdateOrFailute(result, 'Points Updated Successfully', ));
    }
    catch(e){
      emit(state.copyWith(typeResult: TypeResult.failed, ErrorMessage: e.toString()));
    }
  }
  void _validateMember(validateMember event, Emitter<MemberManagementState> emit) async {
    try{
      final result =await  validateMemberUseCase(event.memberid);
      emit(_eitherVerifyOrFailute(result, 'Member Validated Successfully', ));
    }
    catch(e){
      emit(state.copyWith(typeResult: TypeResult.failed, ErrorMessage: e.toString()));
    }
  }





  MemberManagementState _eitherVerifyOrFailute(
      Either<Failure, Unit> failureOrSuccess, String message, ) {
    return failureOrSuccess.fold(
      (failure) => state.copyWith(typeResult: TypeResult.failed, ErrorMessage: mapFailureToMessage(failure)),
      (success) {


        return state.copyWith(typeResult: TypeResult.success, ErrorMessage: message,isUpdated: true);}
    );
  }  MemberManagementState _eitherCotisationOrFailute(
      Either<Failure, Unit> failureOrSuccess, String message, int index,bool cotisation ) {
    return failureOrSuccess.fold(
      (failure) => state.copyWith(typeResult: TypeResult.failed, ErrorMessage: mapFailureToMessage(failure)),
      (success) {
        final List<bool> cotisationList = List.of(state.cotisation);
        cotisationList[index] = cotisation;




        return state.copyWith(typeResult: TypeResult.success, ErrorMessage: message,cotisation: cotisationList);}
    );
  }
  MemberManagementState _eitherUpdateOrFailute(
      Either<Failure, Unit> failureOrSuccess, String message ){
    return failureOrSuccess.fold(
      (failure) => state.copyWith(typeResult: TypeResult.failed, ErrorMessage: mapFailureToMessage(failure)),
      (success) {


        return state.copyWith(typeResult: TypeResult.success, ErrorMessage: message,points: state.clone);}
    );
  }
  MemberManagementState _eitherChangeToAdminOrFailute(
      Either<Failure, Unit> failureOrSuccess, String message,MemberType type ){
    return failureOrSuccess.fold(
      (failure) => state.copyWith(typeResult: TypeResult.failed, ErrorMessage: mapFailureToMessage(failure)),
      (success)
    {
      if (type==MemberType.admin){
      final List<bool> cotisationList = List.of(state.cotisation);
      cotisationList[0] = true;
      if (state.cotisation.length > 1){
        cotisationList[1] = true;
      }

      return state.copyWith(typeResult: TypeResult.success, ErrorMessage: message,role: "admin",
          points: state.points+1000,
          cotisation: cotisationList);}
        else if (type==MemberType.member){


          return state.copyWith(typeResult: TypeResult.success, ErrorMessage: message,role: "member",
             );
        }
    else{

          final List<bool> cotisationList = List.of(state.cotisation);
          cotisationList[0] = true;
          if (state.cotisation.length > 1){
            cotisationList[1] = true;
          }

          return state.copyWith(typeResult: TypeResult.success, ErrorMessage: message,role: "superadmin",
              points: state.points+2000,
              cotisation: cotisationList);
      }}


    );

    }

  MemberManagementState _eitherChangeLanguageOrFailute(Either<Failure, Unit> result, String s, String language) {
    return result.fold(
            (failure) => state.copyWith(typeResult: TypeResult.failed, ErrorMessage: mapFailureToMessage(failure)),
            (success) => state.copyWith(typeResult: TypeResult.success, ErrorMessage: s,));
  }

  MemberManagementState _eitherSendInactivityReportOrFailute(Either<Failure, Unit> result, String s) {
    return result.fold(
            (failure) => state.copyWith(typeResult: TypeResult.failed, ErrorMessage: mapFailureToMessage(failure)),
            (success) => state.copyWith(typeResult: TypeResult.success, ErrorMessage: s,));
  }
}
