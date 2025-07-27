import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/PrimitiveUser/User.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Home/data/datasources/Participants&Guest/Particpant/PaticipantsRemoteDataSource.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';
import 'package:jci_app/features/Home/domain/repsotories/ParticipantsRepo.dart';


class ParticipantsRepoImpl implements ParticipantsRepository {
  final ParticipantsRemoteDataSource participantsRemoteDataSource;
  final Handler<Unit> handler;
  final Handler<List<User>> partHandler;
  final Handler<List<ParticipantDetailsParam>> DetailsHandler;

  ParticipantsRepoImpl({required this.participantsRemoteDataSource, required this.handler, required this.partHandler, required this.DetailsHandler});
///This function is used to update the absence of a member in an activity
  ///It takes the activityId, memberId and status of the member
  ///It returns a unit if the operation is successful
  ///It returns a failure if the operation is not successful
  ///It throws a Failure if an error occurs

  @override
  Future<Either<Failure, Unit>> checkAbsence(String activityId, String memberId, String status) async{
    return await handler.handle(onCall: (){

      participantsRemoteDataSource.checkAbsence(activityId, memberId, status);
      return Future.value(unit);
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
      else{
      throw e;}
    });




     }
     ///This function is used to get all the participants
  ///It returns a list of participants if the operation is successful
  ///It returns a failure if the operation is not successful
  ///It throws a Failure if an error occurs
  ///TODO: Add Pagination with page and limits

  @override
  Future<Either<Failure, List<User>>> getAllParticipants()async {

    return await partHandler.handle(onCall: (){
      final participants=  participantsRemoteDataSource.getAllParticipants();
      return participants;
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
      else{
      throw e;}
    });

  }
  ///This function is used to send a reminder to the participants of an activity
  ///It takes the activityName, activityBeginDate and location
  ///It returns a unit if the operation is successful
  ///It returns a failure if the operation is not successful
  ///It throws a Failure if an error occurs
  ///

  @override
  Future<Either<Failure, Unit>> sendReminderActivity(String ActivityName, String ActivityBeginDate,String location)async {
    return await handler.handle(onCall: (){
      final oo= participantsRemoteDataSource.sendReminder(ActivityName, ActivityBeginDate , location);
      return Future.value(unit);
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
      else{
      throw e;}
    });


  }
  ///This function is used to get the participants of an activity
  ///It takes the activityId
  ///It returns a list of participants if the operation is successful
  ///It returns a failure if the operation is not successful
  ///It throws a Failure if an error occurs
  ///

  @override
  Future<Either<Failure, List<ParticipantDetailsParam>>> GetParticipantsOfActivity(String ActivityId)async {
    return await DetailsHandler.handle(onCall: (){
      final participants=  participantsRemoteDataSource.getAllParticipantsWithStatusOfActivity(ActivityId);
      return participants;
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
      else{
      throw e;}
    });

  }
///This function is used to update the attendance of members in an activity
  ///It takes the activityId and a list of members
  ///It returns a unit if the operation is successful
  ///It returns a failure if the operation is not successful
  ///It throws a Failure if an error occurs

  @override
  Future<Either<Failure, Unit>> updateMembersAttendance(String activityId, List<ParticipantDetailsParam> members) async{
    return await handler.handle(onCall: (){
      participantsRemoteDataSource.updateMembersAttendance(activityId: activityId,members:  members);
      return Future.value(unit);
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
      else{
      throw e;}
    });

  }




}