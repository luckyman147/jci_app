import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/Home/domain/repsotories/AgendaRepo.dart';

import '../entities/Agenda.dart';

class StartMeetingUseCases extends UseCase<Unit,AgendaDto>{
  final AgendaRepo agendaRepo;

  StartMeetingUseCases({required this.agendaRepo});
  @override
  Future<Either<Failure, Unit>> call(AgendaDto params) async{
    return await agendaRepo.StartMeeting(params);
  }

}
class checkAndUpdateActivityStatusUseCases extends UseCase<Unit,String>{
  final AgendaRepo agendaRepo;

  checkAndUpdateActivityStatusUseCases({required this.agendaRepo});
  @override
  Future<Either<Failure, Unit>> call(String params) async{
    return await agendaRepo.checkAndUpdateActivityStatus(params);
  }

}
class areAllPointCompletedUseCases extends UseCase<bool,String>{
  final AgendaRepo agendaRepo;

  areAllPointCompletedUseCases({required this.agendaRepo});
  @override
  Future<Either<Failure, bool>> call(String params)async {
   return await agendaRepo.areAllPointsCompleted(params);
  }
}
class UpdatePointsUsesCases extends UseCase<Unit,AgendaDto>{
  final AgendaRepo agendaRepo;

  UpdatePointsUsesCases({required this.agendaRepo});
  @override
  Future<Either<Failure, Unit>> call(AgendaDto params)async {
    return await agendaRepo.UpdatePoint(params);
  }
}
class UpdateStatusMeetingUsesCases extends UseCase<Unit,AgendaDto>{
  final AgendaRepo agendaRepo;

  UpdateStatusMeetingUsesCases({required this.agendaRepo});
  @override
  Future<Either<Failure, Unit>> call(AgendaDto params)async {
    return await agendaRepo.UpdateStatusMeeting(params);
  }
}
class FetchAgendasUsesCases extends UseCase<Agenda,String>{
  final AgendaRepo agendaRepo;

  FetchAgendasUsesCases({required this.agendaRepo});
  @override
  Future<Either<Failure, Agenda>> call(String params)async {
    return await agendaRepo.FetchAgendas(params);
  }
}