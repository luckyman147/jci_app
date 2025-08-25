import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';

import 'package:jci_app/features/Home/data/datasources/activities/Meetings/MeetingLocaldatasources.dart';
import 'package:jci_app/features/Home/data/datasources/activities/Meetings/Meeting_remote_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/activities/events/Event_local_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/activities/events/event_remote_datasources.dart';
import 'package:jci_app/features/Home/data/datasources/activities/trainings/TrainingLocalDatasources.dart';
import 'package:jci_app/features/Home/data/datasources/activities/trainings/Training_Remote_datasources.dart';
import 'package:jci_app/features/Home/data/model/TrainingModel/TrainingModel.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/MeetingModel.dart';

import 'package:jci_app/features/Home/domain/entities/Activitys/Activity.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/Place.dart';


import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../core/error/Exception.dart';

import '../../domain/entities/Activity/event/Event.dart';
import '../../domain/entities/Meeting.dart';
import '../../domain/entities/training.dart';
import '../../domain/repsotories/ActivitiesRepo.dart';
import '../model/events/EventModel.dart';

class ActivityRepoImpl implements ActivitiesRepo{
  final EventRemoteDataSource eventRemoteDataSource;
  final EventLocalDataSource eventLocalDataSource;
  final MeetingRemoteDataSource meetingRemoteDataSource;
  final MeetingLocalDataSource meetingLocalDataSource;
  final TrainingRemoteDataSource trainingRemoteDataSource;
  final TrainingLocalDataSource trainingLocalDataSource;
final Handler<Unit> Unithandler;
final Handler<bool> boolhandler;
final Handler<Activity> activityHandler;
final Handler<List<Activity>> ListactivityHandler;
final Handler<String> StringHandler;
final Handler<List<Place>> placesHandler;
final Handler<Place> placeHandler;

  ActivityRepoImpl(this.activityHandler, this.ListactivityHandler, this.boolhandler, this.StringHandler, this.placesHandler, this.placeHandler, {required this.eventRemoteDataSource, required this.eventLocalDataSource, required this.meetingRemoteDataSource, required this.meetingLocalDataSource, required this.trainingRemoteDataSource, required this.trainingLocalDataSource, required this.Unithandler});


/// This function is used to create an activity
  /// It takes in an activity object and an activity type
  /// It then calls the handleActivity function from the Handler class
  @override
  Future<Either<Failure, Unit>> createActivity(Activity Activity, activity act)async {


return await Unithandler.handleActivity(
    onCallEvents: ()async   {

  final event=EventModel.fromEntity(event:Activity as Event);

 final newErvent= await eventRemoteDataSource.createEvent(event);
  await eventLocalDataSource.cacheEvent(newErvent);
  return Future.value(unit);


},
    onCallMeetings: ()async   {
      final result= MeetingModel.fromEntities(meeting:Activity as Meeting);

 final newMeet=     await meetingRemoteDataSource.createMeeting(result);
      log("meeting created");
await meetingLocalDataSource.cacheMeeting(newMeet);
      return Future.value(unit);
    },
    onCallTrainings: ()async   {

      final result= TrainingModel.fromEntity( Activity as Training);


  final newtra=    await trainingRemoteDataSource.createTraining(result);
      await trainingLocalDataSource.cacheTraining(newtra);

      return Future.value(unit);
    },

    onCallAll: ()async   {
      final event=EventModel.fromEntity(event:Activity as Event);
 final newevfe=     await eventRemoteDataSource.createEvent(event);

      await eventLocalDataSource.cacheEvent(newevfe);
      return Future.value(unit);
    },

    onError:(e){

      if (e is Exception){
        return e.get_failure;
      }
      throw e;
    } ,
    param: act);
  }
/// This function is used to delete an activity
  /// It takes in an activity object and an activity type
  /// It then calls the handleActivity function from the Handler class
  /// It then calls the delete function from the remote data source
  @override
  Future<Either<Failure, Unit>> deleteActivity(String id, activity act)async {
    return await Unithandler.handleActivity(
        onCallEvents: ()async   {

          await eventRemoteDataSource.deleteEvent(id);
          await eventLocalDataSource.deleteEvent(id);
          return Future.value(unit);},
        onCallMeetings: () async{
       await   meetingRemoteDataSource.deleteMeeting(id);
       await meetingLocalDataSource.deleteMeeting(id);
          return Future.value(unit);
        },
        onCallTrainings: ()async {
        await  trainingRemoteDataSource.deleteTraining(id);
        await trainingLocalDataSource.deleteTraining(id);
          return Future.value(unit);
        },
        onCallAll: ()async {
       await   eventRemoteDataSource.deleteEvent(id);
          return Future.value(unit);
        },
        onError: (e) {
          if (e is Exception){
            return e.get_failure;
          }
          throw e;
        }, param: act);

  }


  @override
  Future<Either<Failure, Unit>> leaveActivity(String id, activity act) async{
    return  Unithandler.handleActivity(
        onCallEvents: ()async   {

          await eventRemoteDataSource.leaveEvent(id);
          return Future.value(unit);},
        onCallMeetings: ()async {
       await   meetingRemoteDataSource.leaveMeeting(id);
          return Future.value(unit);
        },
        onCallTrainings: ()async {
       await   trainingRemoteDataSource.leaveTraining(id);
          return Future.value(unit);
        },
        onCallAll: () async{
       await   eventRemoteDataSource.leaveEvent(id);
          return Future.value(unit);
        },
        onError: (e) {
          if (e is Exception){
            return e.get_failure;
          }
          throw e;
        }, param: act);
  }
  /// This function is used to let user participate in an activity
  /// It takes in an activity object and an activity type

  @override
  Future<Either<Failure, Unit>> participateActivity(String id, activity act)async {
    return await Unithandler.handleActivity(
        onCallEvents: ()async   {

          await eventRemoteDataSource.participateEvent(id);
          return Future.value(unit);},
        onCallMeetings: () async{
        await  meetingRemoteDataSource.participateMeeting(id);
          return Future.value(unit);
        },
        onCallTrainings: ()async {
      await    trainingRemoteDataSource.participateTraining(id);
          return Future.value(unit);
        },
        onCallAll: () async{
      await    eventRemoteDataSource.participateEvent(id);
          return Future.value(unit);
        },
        onError: (e) {
          if (e is Exception){
            return e.get_failure;
          }
          throw e;
        }, param: act);
  }
  /// This function is used to update an activity
  /// It takes in an activity object and an activity type
  /// It then calls the handleActivity function from the Handler class

  @override
  Future<Either<Failure, Unit>> updateActivity(Activity activity, activity act)async{
    return await Unithandler.handleActivity(
        onCallEvents: ()   {
          final event=EventModel.fromEntity(event:activity as Event);

           eventRemoteDataSource.updateEvent(event);
          return Future.value(unit);},
        onCallMeetings: () {
          final result= MeetingModel.fromEntities(meeting:activity as Meeting);
          meetingRemoteDataSource.updateMeeting(result);
          return Future.value(unit);
        },
        onCallTrainings: () {
          final result= TrainingModel.fromEntity(activity as Training);
          trainingRemoteDataSource.updateTraining(result);
          return Future.value(unit);
        },
        onCallAll: () {
          final event=EventModel.fromEntity(event:activity as Event);
           eventRemoteDataSource.updateEvent(event);
          return Future.value(unit);
        },
        onError: (e) {
          if (e is Exception){
            return e.get_failure;
          }
          throw e;
        }, param: act);

  }
/// This function is used to get an activity by its id
  /// It takes in an activity object and an activity type
  /// It then calls the handleActivity function from the Handler class
  /// It then calls the getEventById function from the remote data source
  @override
  Future<Either<Failure, Activity>> getActivityById(String id, activity act)async  {
    return await activityHandler.handleActivity(
        onCallEvents: () async  {
          final local= await eventLocalDataSource.getEventById(id);
          if (local!=null){
            return Future.value(local);
          }

          final result=await eventRemoteDataSource.getEventById(id);

          await eventLocalDataSource.cacheEvent(result);
          await eventLocalDataSource.CacheEventById(result);

          log("event cached");
          return Future.value(result);

        },
        onCallMeetings: ()  async {
          final local=await meetingLocalDataSource.getCachedMeetingById(id);
          if (local==null){
          final result=await meetingRemoteDataSource.getMeetingById(id);
          await meetingLocalDataSource.cacheMeetingById(result);
          return Future.value(result);
        }
          return Future.value(local);

          },
        onCallTrainings: () async  {
          final local= await trainingLocalDataSource.getCachedTrainingById(id);
          if (local!=null){
            return Future.value(local);
          }
          final result= await trainingRemoteDataSource.getTrainingById(id);
          return Future.value(result);
        },
        onCallAll: ()   {
          final result= eventRemoteDataSource.getEventById(id);
          return Future.value(result);
        },
        onError: (e) {
          if (e is Exception){
            return e.get_failure;
          }
          throw e;
        }, param: act);
  }

  /// This function is used to get all activities
  /// It takes in an activity object and an activity type
  /// It then calls the handleActivity function from the Handler class

  @override
  Future<Either<Failure, List<Activity>>> getAllActivities(activity act)async  {
    return await ListactivityHandler.handleActivity(
        onCallEvents: ()async   {
// get from cache
          final result=await eventLocalDataSource.getAllCachedEvents();
          if(result.isEmpty || result.length<2){
            final remoteEvents=await eventRemoteDataSource.getAllEvents();
            //cache the new events

            await eventLocalDataSource.cacheEvents(remoteEvents);
            return  remoteEvents;
          }

          return result;

        },
        onCallMeetings: ()async   {
final result=await meetingLocalDataSource.getAllCachedMeetings();
if(result.isEmpty || result.length<2) {

  final remoteEvents = await meetingRemoteDataSource.getAllMeetings();
  await meetingLocalDataSource.cacheMeetings(remoteEvents);
  return remoteEvents;
}
return result;


        },
        onCallTrainings: ()async   {
          final result=await trainingLocalDataSource.getAllCachedTrainings();
          if(result.isEmpty || result.length<2) {
            final remoteEvents = await trainingRemoteDataSource
                .getAllTraining();
            await trainingLocalDataSource.cacheTrainings(remoteEvents);
            return remoteEvents;
          }
          return result;


        },
        onCallAll: ()async   {
          final result=await eventRemoteDataSource.getAllEvents();
          await eventLocalDataSource.cacheEvents(result);
          return Future.value(result);
        },
        onError: (e) {

          if (e is Exception){
            return e.get_failure;
          }
          throw e;
        }, param: act);




  }
/// this function is to checkPermissions
  /// It takes  an activity type

  @override
  Future<Either<Failure, bool>> checkPermissions(activity act)async {
    return await boolhandler.handleActivity(
        onCallEvents: ()   {
          final result= eventLocalDataSource.checkPermissions();
          return Future.value(result);

        },
        onCallMeetings: ()async   {
          final result= meetingLocalDataSource.checkPermissions();
          return Future.value(result);
        },
        onCallTrainings: ()async   {
          final result= trainingLocalDataSource.checkPermissions();
          return Future.value(result);
        },
        onCallAll: ()async   {
          final result= eventLocalDataSource.checkPermissions();
          return Future.value(result);
        },
        onError: (e) {
          if (e is Exception){
            return e.get_failure;
          }
          throw e;
        }, param: act);
  }
/// this function is to getActivityByName
  @override
  Future<Either<Failure, List<Activity>>> getActivityByName(String name, activity act) async{
    return await ListactivityHandler.handle(onCall: ()async{
      final  result=await eventRemoteDataSource.GetactivityByName(name, act);
      if (result.isEmpty){
        throw NotFoundException();
      }
      return result;
    }, onError: (e){
      if (e is Exception){
        return e.get_failure;
      }
      throw e;
    });
  }

  @override
  Future<Either<Failure, List<Place>>> SearchPlaces(String name) async{
    return await placesHandler.handle(onCall: ()async{
      final result=await eventRemoteDataSource.getPlacesByName(name);
      if (result.isEmpty){
        throw NotFoundException();
      }
      return result;
    }, onError: (e){
      if (e is Exception){
        return e.get_failure;
      }
      throw e;
    });
  }

  @override
  Future<Either<Failure, Place>> SearchPlacesDetails(Place name) async{
    return await placeHandler.handle(onCall: ()async{
      final result=await eventRemoteDataSource.getPlaceDetail(name);
      if (result==null){
        throw NotFoundException();
      }
      return result;
    }, onError: (e){
      if (e is Exception){
        return e.get_failure;
      }
      throw e;
    });
  }












}