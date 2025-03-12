import 'package:jci_app/features/Home/domain/entities/guest/Guest.dart';

import '../../../auth/domain/usecases/USesCasesGlobal.dart';
import '../entities/guest/ActivityGuest.dart';

abstract class GuestsRepository {
  Future<Either<Failure, List<Guest>>> getAllGuests(bool isUpdated);
  Future<Either<Failure, Unit>> addGuest(String activityId, Guest guest);
  Future<Either<Failure, Unit>> addGuestToActivity(String activityId, String guestId);
  Future<Either<Failure, Unit>> deleteGuest(String activityId, String guestId);
  Future<Either<Failure, Unit>> changeGuestToMember(String guestId);
  Future<Either<Failure, Unit>> updateGuest(String activityId, Guest guest);
  Future<Either<Failure, List<ActivityGuest>>> getAllGuestsOfActivity(String activityId);
  Future<Either<Failure, Unit>> updateGuestStatus(String activityId, String guestId, String status);
}
