import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../entities/Agenda.dart';

abstract class AgendaRepo{

  Future<Either<Failure,Unit>> StartMeeting(AgendaDto agendaDto);
  Future<Either<Failure,Unit>> checkAndUpdateActivityStatus(String activityId);

  /// Checks if all points in the activity are completed.
  Future<Either<Failure,bool>> areAllPointsCompleted(String activityId);
  /// Starts the next point in the agenda.

  Future<Either<Failure,Unit>> UpdatePoint(AgendaDto agenda);
  Future<Either<Failure,Unit>> SendNotifications(AgendaDto agendaDto);
  Future<Either<Failure,Unit>> UpdateStatusMeeting(AgendaDto agenda
      );

  Future<Either<Failure,Agenda>> FetchAgendas(String ActivityId);

}

class AgendaDto{
  final List<Agenda> agendas;
  final String ActivityId;
  final Agenda? agenda;
  final AgendaStatus status;

  AgendaDto(this.status, {required this.agendas, required this.ActivityId, required this.agenda});
}
enum AgendaStatus{
  Completed,
  InProgress,
  NotStarted
}