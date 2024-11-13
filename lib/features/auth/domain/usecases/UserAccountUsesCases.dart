

import 'package:jci_app/core/Member.dart';
import 'package:jci_app/features/auth/domain/dtos/CheckOtopDtos.dart';

import '../dtos/ResetpasswordDtos.dart';
import 'USesCasesGlobal.dart';

class UpdatePasswordUseCase extends UseCase<Unit, ResetpasswordDtos> {
  final UserAccountRepo  userAccountRepo;

  UpdatePasswordUseCase({required this.userAccountRepo});

  @override
  Future<Either<Failure, Unit>> call( member) async {
    return await userAccountRepo.updatePassword(member);
  }

}

class SendVerifyCodeUseCases extends UseCase<Unit, String>{
  final UserAccountRepo userAccountRepo;

  SendVerifyCodeUseCases(this.userAccountRepo);
  @override
  Future<Either<Failure, Unit>> call(String email) async {
    return await userAccountRepo.sendVerificationEmail(email);
  }


}

class CheckOtpUseCase extends UseCase<Unit, String>{
  final UserAccountRepo userAccountRepo;

  CheckOtpUseCase(this.userAccountRepo);
  @override
  Future<Either<Failure, Unit>> call(String check) async {
    return await userAccountRepo.checkOtp(check);
  }

}
class RefreshTokenUseCase extends UseCase<Unit, NoParams> {
  final UserAccountRepo userAccountRepository;

  RefreshTokenUseCase({required this.userAccountRepository});

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await userAccountRepository.refreshToken();
  }
}
class SendResetPasswordEmailUseCase extends UseCase<Unit, String>{
  final UserAccountRepo userAccountRepo;

  SendResetPasswordEmailUseCase(this.userAccountRepo);
  @override
  Future<Either<Failure, Unit>> call(String email) async {
    return await userAccountRepo.sendResetPasswordEmail(email);
  }

}