import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';

abstract class Failure extends Equatable {
  final List properties = const <dynamic>[];

const Failure([properties]);

@override
List<dynamic> get props => properties;

  static Future<Either<Failure, CheckList>> fromException(e) {
    if (e is Exception){
      throw e;
    }
    throw Exception('Unknown error occurred');
  }}

class OfflineFailure extends Failure {

}
class NotFoundFailure extends Failure {

}
class ServerFailure extends Failure {
}

class EmptyCacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}
class EmptyDataFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmailExistedFailure extends Failure {
  @override
  List<Object?> get props => [];
}
class WrongCredentialsFailure extends Failure {
  @override
  List<Object?> get props => [];
}class ExpiredFailure extends Failure {

}
class AlreadyLogoutFailure extends Failure {

}
class UnauthorizedFailure extends Failure {

}
class UnexpectedFailure extends Failure {

}
class NoInternetFailure extends Failure {

}
class AlreadyParticipatedFailure extends Failure {

}
class WrongVerificationCodeFailure extends Failure {

}
class WrongVerificationFailure extends Failure {
}

class AlreadyParticipateFailure extends Failure {
}

class AlreadyRegisterFailure extends Failure {
}

class AlreadyLoginFailure extends Failure {
}
class NotVerifiedFailure extends Failure {
}
class AlreadyExistedFailure extends Failure{}