import 'package:dartz/dartz.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/MemberRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../../../auth/domain/entities/Member.dart';

class GetUserProfile extends UseCase<Member , bool>{
  final MemberRepo authRepository;

  GetUserProfile({required this.authRepository});

  @override
  Future<Either<Failure, Member >> call(bool Params) async {
    return await authRepository.GetUserProfile(Params);
  }

}
class GetAllMembersUseCase extends UseCase<List<Member>, NoParams>{
  final MemberRepo authRepository;

  GetAllMembersUseCase({required this.authRepository});

  @override
  Future<Either<Failure, List<Member>>> call(NoParams) async {
    return await authRepository.GetMembers();
  }

}class GetMemberByname extends UseCase<List<Member>, String >{
  final MemberRepo authRepository;

  GetMemberByname({required this.authRepository});

  @override
  Future<Either<Failure, List<Member>>> call(String params) async {
    return await authRepository.GetMemberByName(params);
  }

}
class UpdateMemberUseCase extends UseCase<Unit, Member>{
  final MemberRepo authRepository;

  UpdateMemberUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(Member params) async {
    return await authRepository.updateMember(params);
  }

}