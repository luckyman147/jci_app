import 'package:jci_app/core/error/Failure.dart';

class ServerException implements Exception {}

class EmptyCacheException implements Exception {}
class EmptyDataException implements Exception {}
class OfflineException implements Exception {}
class IsEmailException implements Exception {}
class WrongCredentialsException implements Exception {}
class ExpiredException implements Exception {}
class UnauthorizedException implements Exception {}
class NotFoundException implements Exception {}

class AlreadyLogoutException implements Exception {}
class AlreadyLoginException implements Exception {}
class AlreadyRegisterException implements Exception {}
class AlreadyParticipateException implements Exception {}
class WrongVerificationException implements Exception {}
class NotVerifiedException implements Exception {}


extension MessgeException on
Exception {
  Failure  get get_failure {
    switch (runtimeType) {
      case ServerException:
        return ServerFailure();
      case EmptyCacheException:
        return EmptyCacheFailure();
      case EmptyDataException:
        return EmptyDataFailure();
       case NotVerifiedException:
        return NotVerifiedFailure();
      case OfflineException:
        return OfflineFailure();
      case WrongVerificationException:
        return WrongVerificationFailure();


      case WrongCredentialsException:
        return WrongCredentialsFailure();
      case ExpiredException:
        return ExpiredFailure();
      case UnauthorizedException:
        return UnauthorizedFailure();
      case NotFoundException:
        return NotFoundFailure();
      case AlreadyLogoutException:
        return AlreadyLogoutFailure();
      case AlreadyLoginException:
        return AlreadyLoginFailure();
      case AlreadyRegisterException:
        return AlreadyRegisterFailure();
      case AlreadyParticipateException:
        return AlreadyParticipateFailure();

      default:
        return ServerFailure();

    }
  }
}



