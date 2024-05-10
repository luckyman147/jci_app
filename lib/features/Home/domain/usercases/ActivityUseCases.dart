import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/domain/entities/Guest.dart';
import 'package:jci_app/features/Home/domain/repsotories/ActivitiesRepo.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import '../entities/ActivityParticpants.dart';

class GetAllActivitiesUseCases extends UseCase<List<Activity>,activity >{
  final ActivitiesRepo activitiesRepo;

  GetAllActivitiesUseCases({required this.activitiesRepo});
  @override
  Future<Either<Failure, List<Activity>>> call(activity params) {
    return activitiesRepo.getAllActvities(params);

  }
}
class GetActivityByIdUseCases extends UseCase<Activity,activityParams >{
  final ActivitiesRepo activitiesRepo;

  GetActivityByIdUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Activity>> call(activityParams params) {
    return activitiesRepo.getActivityById(params.id!, params.type);
  }
}class GetActivityByNameUseCases extends UseCase<List<Activity>,activityParams >{
  final ActivitiesRepo activitiesRepo;

  GetActivityByNameUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, List<Activity>>> call(activityParams params) {
    return activitiesRepo.getActivityByname(params.name!, params.type);
  }
}

class CreateActivityUseCases extends UseCase<Unit,activityParams >{
  final ActivitiesRepo activitiesRepo;

  CreateActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.createEvent(params.act!, params.type);
  }


}

class UpdateActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  UpdateActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.updateEvent(params.act!, params.type);
  }
}
class DeleteActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  DeleteActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.deleteEvent(params.id!, params.type);
  }
}
class LeaveActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  LeaveActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.leaveEvent(params.id!, params.type);
  }
}
class ParticipateActivityUseCases extends UseCase<Unit,activityParams > {
  final ActivitiesRepo activitiesRepo;

  ParticipateActivityUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(activityParams params) {
    return activitiesRepo.participateEvent(params.id!, params.type);
  }
}
class CheckAbsenceUseCases extends UseCase<Unit,ParticipantsParams > {
  final ActivitiesRepo activitiesRepo;

  CheckAbsenceUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(ParticipantsParams params) {
    return activitiesRepo.CheckAbsence(params.ActivityId, params.partipantId, params.status);
  }
}
class GetAllParticipantsUseCases extends UseCase<List<ActivityParticipants>,String > {
  final ActivitiesRepo activitiesRepo;

  GetAllParticipantsUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, List<ActivityParticipants>>> call( params) {
    return activitiesRepo.getAllParticipants(params);
  }
}
class GetGuestsUseCases extends UseCase<List<Guest>,String > {
  final ActivitiesRepo activitiesRepo;

  GetGuestsUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, List<Guest>>> call( params) {
    return activitiesRepo.getAllguestOfActivity(params);
  }
}class GetAllGuestsUseCases extends UseCase<List<Guest>,bool > {
  final ActivitiesRepo activitiesRepo;

  GetAllGuestsUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, List<Guest>>> call( params) {
    return activitiesRepo.getAllguest(params);
  }
}
class AddGuestUseCases extends UseCase<Unit,guestParams > {
  final ActivitiesRepo activitiesRepo;

  AddGuestUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(guestParams params) {
    return activitiesRepo.addGuest(params.activityid!, params.guest!);
  }
}
class ConfirmGuestUseCases extends UseCase<Unit,guestParams > {
  final ActivitiesRepo activitiesRepo;

  ConfirmGuestUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(guestParams params) {
    return activitiesRepo.updateGuestStatus(params.activityid!, params.guestId!, params.isConfirmed!);
  }
}
class DeleteGuestUseCases extends UseCase<Unit,guestParams > {
  final ActivitiesRepo activitiesRepo;

  DeleteGuestUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(guestParams params) {
    return activitiesRepo.deleteGuest(params.activityid!, params.guestId!);
  }
}
class UpdateGuestUseCases extends UseCase<Unit,guestParams > {
  final ActivitiesRepo activitiesRepo;

  UpdateGuestUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call(guestParams params) {
    return activitiesRepo.updateGuest(params.activityid!, params.guest!);
  }
}
class SendReminderUseCases extends UseCase<Unit,String > {
  final ActivitiesRepo activitiesRepo;

  SendReminderUseCases({required this.activitiesRepo});

  @override
  Future<Either<Failure, Unit>> call( params) {
    return activitiesRepo.SendRemiderActivity(params);
  }
}


class guestParams {
  final Guest? guest;
  final String? guestId;
  final bool? isConfirmed;
  final String? activityid;

  guestParams({required this.guest, required this.guestId, required this.isConfirmed, required this.activityid});

}

class ParticipantsParams{
  final String ActivityId;
  final String partipantId;
  final String status;

  ParticipantsParams({required this.ActivityId, required this.partipantId, required this.status});
}



class activityParams {
  final Activity? act;
  final activity type;
final String? id;
final String? name;
  activityParams( {required this.act, required this.type,required this.id,required this.name});
}