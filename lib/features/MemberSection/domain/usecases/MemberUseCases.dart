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




class ChangeRoleUseCase extends UseCase<Unit, ChangeRoleParams>{
  final MemberRepo authRepository;

  ChangeRoleUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(ChangeRoleParams params) async {
    return await authRepository.ChangeToAdmin(params.id, params.type);
  }

}
class DeleteMemberUseCase extends UseCase<Unit, String>{
  final MemberRepo authRepository;

  DeleteMemberUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await authRepository.deleteMember(params);
  }

}
class ChangeRoleParams{
  final String id;
  final MemberType type;

  ChangeRoleParams({required this.id, required this.type});
}






class GetAllMembersUseCase extends UseCase<List<Member>, bool>{
  final MemberRepo authRepository;

  GetAllMembersUseCase({required this.authRepository});

  @override
  Future<Either<Failure, List<Member>>> call(param) async {
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
class UpdatePointsUseCase extends UseCase<Unit, UpdatePointsParams>{
  final MemberRepo authRepository;

  UpdatePointsUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(UpdatePointsParams params) async {
    return await authRepository.UpdatePoints(params.memberid, params.points);
  }

}
class UpdateCotisationUseCase extends UseCase<Unit, UpdateCotisationParams>{
  final MemberRepo authRepository;

  UpdateCotisationUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(UpdateCotisationParams params) async {
    return await authRepository.UpdateCotisation(params.memberid,params.type, params.cotisation);
  }

}

class UpdateCotisationParams {
  final String memberid;
  final bool cotisation;
  final int type;

  UpdateCotisationParams({required this.memberid, required this.cotisation, required this.type});
}
class validateMemberuseCase extends UseCase<Unit, String>{
  final MemberRepo authRepository;

  validateMemberuseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await authRepository.validateMember(params);
  }

}
class ChangeLanguageUseCase extends UseCase<Unit, String>{
  final MemberRepo authRepository;

  ChangeLanguageUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await authRepository.ChangeLanguage(params);
  }

}
class SendMembershipReportUseCase extends UseCase<Unit, String>{
  final MemberRepo authRepository;

  SendMembershipReportUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await authRepository.SendMembershipReport(params);
  }

}
class SendInactivityReportUseCase extends UseCase<Unit, String>{
  final MemberRepo authRepository;

  SendInactivityReportUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(String params) async {
    return await authRepository.SendInactivityReport(params);
  }

}

class UpdatePointsParams {
  final String memberid;
  final double points;


  UpdatePointsParams({required this.memberid, required this.points});
}