import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';

import '../entities/Member.dart';
import '../repositories/AuthRepo.dart';


class RefreshTokenUseCase extends UseCase<bool, NoParams> {
  final AuthRepo authRepository;

  RefreshTokenUseCase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
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
class GetUserProfile extends UseCase<Unit, NoParams>{
  final AuthRepo authRepository;

  GetUserProfile({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(NoParams) async {
    return await authRepository.GetUserProfile();
  }

}
class GetAllMembersUseCase extends UseCase<List<Member>, NoParams>{
  final AuthRepo authRepository;

  GetAllMembersUseCase({required this.authRepository});

  @override
  Future<Either<Failure, List<Member>>> call(NoParams) async {
    return await authRepository.GetAllMembers();
  }

}class GetMemberByname extends UseCase<List<Member>, String >{
  final AuthRepo authRepository;

  GetMemberByname({required this.authRepository});

  @override
  Future<Either<Failure, List<Member>>> call(String params) async {
    return await authRepository.GetMemberByName(params);
  }

}