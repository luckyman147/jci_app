import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Home/data/model/GuestModel.dart';
import 'package:jci_app/features/Home/domain/entities/guest/Guest.dart';
import 'package:jci_app/features/Home/domain/repsotories/GuestRepsotories.dart';

import '../../../domain/entities/guest/ActivityGuest.dart';
import '../../datasources/Participants&Guest/Guest/GuestRemoteDataSources.dart';

class GuestRepoImpl implements GuestsRepository {
  final GuestRemoteDataSources guestRemoteDataSources;
  final Handler<Unit > unitHandler;
  final Handler<ActivityGuest> actiguestHandler;
  final Handler<List<ActivityGuest>> actiguestsHandler;
  final Handler<List<Guest>> guestsHandler;

  GuestRepoImpl({required this.guestRemoteDataSources, required this.unitHandler, required this.actiguestHandler, required this.actiguestsHandler, required this.guestsHandler});
  @override
  Future<Either<Failure, Unit>> addGuest(String activityId, Guest guest) async{
    return await unitHandler.handle(onCall: ()async{
      final result=await guestRemoteDataSources.addGuest(activityId, GuestModel.fromEntity(guest));
      return result;
    },
        onError: (e){
      if    (e is Exception){
        return e.get_failure;

      }
      throw ServerException();
        });
  }

  @override
  Future<Either<Failure, Unit>> addGuestToActivity(String activityId, String guestId)async {
    return await unitHandler.handle(onCall: (){
      final res=guestRemoteDataSources.addGuestToActivity(activityId, guestId);
      return res;
    }, onError: (e){
      if    (e is Exception){
        return e.get_failure;

      }
      throw ServerException();
    } );
  }

  @override
  Future<Either<Failure, Unit>> changeGuestToMember(String guestId) {
    // TODO: implement changeGuestToMember
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> deleteGuest(String activityId, String guestId) async{
    return await unitHandler.handle(onCall: (){
      final res=guestRemoteDataSources.deleteGuest(activityId, guestId);
      return res;
    }, onError: (e){
      if    (e is Exception){
        return e.get_failure;

      }
      throw ServerException();
    } );
  }

  @override
  Future<Either<Failure, List<Guest>>> getAllGuests(bool isUpdated)async {
    return await guestsHandler.handle(onCall: (){
      final res=guestRemoteDataSources.getAllGuest();
      return res;
    }, onError: (e){
      if    (e is Exception){
        return e.get_failure;

      }
      throw ServerException();
    } );
  }

  @override
  Future<Either<Failure, List<ActivityGuest>>> getAllGuestsOfActivity(String activityId)async {
    return await actiguestsHandler.handle(onCall: (){
      final res=guestRemoteDataSources.getAllGuestOfACtivity(activityId);
      return res;
    }, onError: (e){
      if    (e is Exception){
        return e.get_failure;

      }
      throw ServerException();
    } );
  }

  @override
  Future<Either<Failure, Unit>> updateGuest(String activityId, Guest guest)async {
    return await unitHandler.handle(onCall: (){
      final res=guestRemoteDataSources.updateGuest(activityId, GuestModel.fromEntity(guest));
      return res;
    }, onError: (e){
      if    (e is Exception){
        return e.get_failure;

      }
      throw ServerException();
    } );
  }

  @override
  Future<Either<Failure, Unit>> updateGuestStatus(String activityId, String guestId, String status) async{
    return await unitHandler.handle(onCall: (){
      final res=guestRemoteDataSources.updateGuestStatus(activityId, guestId,status);
      return res;
    }, onError: (e){
      if    (e is Exception){
        return e.get_failure;

      }
      throw ServerException();
    } );
  }

}