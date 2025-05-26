import 'package:dartz/dartz.dart';
import 'package:jci_app/core/PrimitiveUser/User.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/MemberRepo.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../../../../core/Member.dart';

class GetUserProfile extends UseCase<Member , bool>{
  final MemberRepo authRepository;

  GetUserProfile({required this.authRepository});

  @override
  Future<Either<Failure, Member >> call(bool Params) async {
    return await authRepository.GetUserProfile(Params);
  }

}






class GetAllMembersUseCase extends UseCase<List<User>, bool>{
  final MemberRepo authRepository;

  GetAllMembersUseCase({required this.authRepository});

  @override
  Future<Either<Failure, List<User>>> call(param) async {
    return await authRepository.GetMembers(param);
  }

}class GetMemberByname extends UseCase<List<Member>, String >{
  final MemberRepo authRepository;

  GetMemberByname({required this.authRepository});

  @override
  Future<Either<Failure, List<Member>>> call(String params) async {
    return await authRepository.GetMemberByName(params);
  }

}class GetMembersByRanksUseCases extends UseCase<List<Member>, bool >{
  final MemberRepo authRepository;

  GetMembersByRanksUseCases({required this.authRepository});

  @override
  Future<Either<Failure, List<Member>>> call( params) async {
    return await authRepository.GetMembersRank(params);
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
class GetMemberByIdUseCase extends UseCase<Member, MemberInfoParams>{
  final MemberRepo authRepository;

  GetMemberByIdUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Member>> call(MemberInfoParams params) async {
    return await authRepository.getMemberByid(params.id,params.status);
  }

}
class GetMemberByRankUseCase extends UseCase<Member, bool>{
  final MemberRepo authRepository;

  GetMemberByRankUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Member>> call( params) async {
    return await authRepository.GetMembeWithHighestRank(params);
  }

}
class MemberInfoParams {
  final String id;
  final bool status;

  MemberInfoParams({required this.id, required this.status});
}




class ChangeLanguageUseCase extends UseCase<Unit, String>{
  final MemberRepo authRepository;

  ChangeLanguageUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await authRepository.ChangeLanguage(params);
  }

}



