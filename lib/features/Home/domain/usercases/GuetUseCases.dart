import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/domain/Dtos/GuestParam.dart';
import 'package:jci_app/features/Home/domain/entities/guest/Guest.dart';
import 'package:jci_app/features/Home/domain/repsotories/GuestRepsotories.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';

import '../entities/guest/ActivityGuest.dart';

class ChangeGuestToMemberUseCases extends UseCase<Unit,String >{
  final GuestsRepository guestsRepository;

  ChangeGuestToMemberUseCases({required this.guestsRepository});

  @override
  Future<Either<Failure, Unit>> call( params) {
    return guestsRepository.changeGuestToMember(params);
  }
}

class GetGuestsUseCases extends UseCase<List<ActivityGuest>,String > {
  final GuestsRepository guestsRepository;

  GetGuestsUseCases({required this.guestsRepository});

  @override
  Future<Either<Failure, List<ActivityGuest>>> call( params) {
    return guestsRepository.getAllGuestsOfActivity(params);
  }
}class GetAllGuestsUseCases extends UseCase<List<Guest>,bool > {
  final GuestsRepository guestsRepository;

  GetAllGuestsUseCases({required this.guestsRepository});

  @override
  Future<Either<Failure, List<Guest>>> call( params) {
    return guestsRepository.getAllGuests(params);
  }
}
class AddGuestUseCases extends UseCase<Unit,guestParams > {
  final GuestsRepository guestsRepository;

  AddGuestUseCases({required this.guestsRepository});

  @override
  Future<Either<Failure, Unit>> call(guestParams params) {
    return guestsRepository.addGuest(params.activityid!, params.guest!.guest);
  }
}class AddGuestToActivityUseCases extends UseCase<Unit,guestParams > {
  final GuestsRepository guestsRepository;

  AddGuestToActivityUseCases({required this.guestsRepository});

  @override
  Future<Either<Failure, Unit>> call(guestParams params) {
    return guestsRepository.addGuestToActivity(params.activityid!, params.guestId!);
  }
}
class ConfirmGuestUseCases extends UseCase<Unit,guestParams > {
  final GuestsRepository guestsRepository;

  ConfirmGuestUseCases({required this.guestsRepository});

  @override
  Future<Either<Failure, Unit>> call(guestParams params) {
    return guestsRepository.updateGuestStatus(params.activityid!, params.guestId!, params.status!);
  }
}
class DeleteGuestUseCases extends UseCase<Unit,guestParams > {
  final GuestsRepository guestsRepository;

  DeleteGuestUseCases({required this.guestsRepository});

  @override
  Future<Either<Failure, Unit>> call(guestParams params) {
    return guestsRepository.deleteGuest(params.activityid!, params.guestId!);
  }
}
class UpdateGuestUseCases extends UseCase<Unit,guestParams > {
  final GuestsRepository guestsRepository;

  UpdateGuestUseCases({required this.guestsRepository});

  @override
  Future<Either<Failure, Unit>> call(guestParams params) {
    return guestsRepository.updateGuest(params.activityid!, params.guest!.guest);
  }
}