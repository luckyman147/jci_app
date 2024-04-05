import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';

import '../entities/Member.dart';
import '../repositories/AuthRepo.dart';


class RefreshTokenUseCase extends UseCase<Unit, NoParams> {
  final AuthRepo authRepository;

  RefreshTokenUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await authRepository.refreshToken();
  }
}
class SignOutUseCase extends UseCase<bool, NoParams> {
  final AuthRepo authRepository;

  SignOutUseCase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.signOut();
  }
}
class UpdatePasswordUseCase extends UseCase<Unit, Member> {
  final AuthRepo authRepository;

  UpdatePasswordUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(Member member) async {
    return await authRepository.updatePassword(member);
  }

}
class UpdateLoggedInUseCase extends UseCase<Unit, bool> {
  final AuthRepo authRepository;

  UpdateLoggedInUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(bool value) async {
    return await authRepository.updateLoggedIn(value);
  }

}
class IsLoggedInUseCase extends UseCase<bool, NoParams> {
  final AuthRepo authRepository;

  IsLoggedInUseCase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.isLoggedIn();
  }

}
