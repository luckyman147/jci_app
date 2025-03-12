import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Exception.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Home/data/datasources/activities/Meetings/AgendaRemoteDatasources.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/AgendaModel.dart';
import 'package:jci_app/features/Home/domain/entities/Agenda.dart';

import '../../../domain/repsotories/AgendaRepo.dart';

class AgedaRepoImpl implements AgendaRepo {
  final Handler<Unit> handler;
final Handler<bool> boolHandler;
final AgendaRemoteDataSource agendaRemoteDataSource;

  AgedaRepoImpl({required this.handler,required this.agendaRemoteDataSource, required this.boolHandler});

  @override
  Future<Either<Failure, Unit>> SendNotifications(AgendaDto agendaDto) {
    // TODO: implement SendNotifications
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> StartMeeting(AgendaDto agendaDto)async {
    return  handler.handle(onCall: ()async {
      final res =await  agendaRemoteDataSource.StartMeeting(agendaDto.ActivityId,agendaDto.agendas.map((e) => AgendaModel.fromEntities(e)).toList());
      return res;
    }, onError: (e){
      if (e is Exception){
        throw e.get_failure;
      }
      throw ServerException();
    });
  }

  @override
  Future<Either<Failure, bool>> areAllPointsCompleted(String activityId)async {
    return await boolHandler.handle(onCall: () async{
      final res = await agendaRemoteDataSource.areAllPointsCompleted(activityId);
      return res;
    }, onError: (e){
      if (e is Exception){
        throw e.get_failure;
      }
      throw ServerException();
    });
  }

  @override
  Future<Either<Failure, Unit>> checkAndUpdateActivityStatus(String activityId) async{
    return await handler.handle(onCall: ()async {
      final res =await  agendaRemoteDataSource.checkAndUpdateActivityStatus(activityId);
      return res;
    }, onError: (e){
      if (e is Exception){
        throw e.get_failure;
      }
      throw ServerException();
    });
  }

  @override
  Future<Either<Failure, Unit>> UpdatePoint(AgendaDto agenda) async{
    return await handler.handle(onCall: ()async {
      await  agendaRemoteDataSource.updateCurrentPoint(agenda.ActivityId);
await  agendaRemoteDataSource.startNextPoint(agenda.ActivityId,agenda.agendas.map((e)=>AgendaModel.fromEntities(e)).toList());
      return unit;

    }, onError: (e){
      if (e is Exception){
        throw e.get_failure;
      }
      throw ServerException();
    });
  }

  @override
  Future<Either<Failure, Unit>> UpdateStatusMeeting(AgendaDto agenda)async {
    return await handler.handle(onCall: ()async{
      await agendaRemoteDataSource.UpdateMeetingStatus(agenda.ActivityId, agenda.status.name);
      return unit;
    }, onError: (e){


    if (e is Exception){
    throw e.get_failure;
    }
    throw ServerException();
    }


    );
  }

  @override
  Future<Either<Failure, Agenda>> FetchAgendas(String ActivityId) {
    // TODO: implement FetchAgendas
    throw UnimplementedError();
  }


}