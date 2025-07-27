import 'package:dartz/dartz.dart';
import 'package:jci_app/features/auth/domain/repositories/UserStatusRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';

class UpdateLoggedInUseCase extends UseCase<Unit, bool> {
  final UserStatusRepo authRepository;

  UpdateLoggedInUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(bool value) async {
    return await authRepository.updateLoggedIn(value);
  }

}
class IsLoggedInUseCase extends UseCase<bool, NoParams> {
  final UserStatusRepo authRepository;

  IsLoggedInUseCase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.isLoggedIn();
  }

}
class GetPreviousEmailUseCase extends UseCase<String, NoParams> {
  final UserStatusRepo authRepository;

  GetPreviousEmailUseCase({required this.authRepository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await authRepository.getPreviousEmail();
  }

}
class IsNewMemberUseCase extends UseCase<bool, NoParams> {
  final UserStatusRepo userStatusRepo;

  IsNewMemberUseCase({required this.userStatusRepo});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await userStatusRepo.isNewMember();
  }

}