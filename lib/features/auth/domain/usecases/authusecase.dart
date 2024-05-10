import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
class SignOutUseCase extends UseCase<bool, bool> {
  final AuthRepo authRepository;

  SignOutUseCase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(bool params) async {
    return await authRepository.signOut(params);
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
class LoginUseCase {
final AuthRepo _loginRepo;

  LoginUseCase(this._loginRepo);


  Future<Either<Failure, Unit>> LoginCredentials(String email,String password) async {
    return await _loginRepo.LogInWithCredentials(email, password);
  }
}
class SignUpUseCase extends UseCase<Unit, SignField> {
  final AuthRepo authRepository;

  SignUpUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call( signfield) async {
    return await authRepository.signUpWithCredentials(signfield.member!, signfield.otp);
  }

}
class SignField{
  final Member? member;
  final String otp;

  SignField({required this.member, required this.otp});

}
class IsLoggedInUseCase extends UseCase<bool, NoParams> {
  final AuthRepo authRepository;

  IsLoggedInUseCase({required this.authRepository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.isLoggedIn();
  }

}
class SendVerifyCodeUseCases extends UseCase<Unit, String>{
  final AuthRepo _loginRepo;

  SendVerifyCodeUseCases(this._loginRepo);
  @override
  Future<Either<Failure, Unit>> call(String email) async {
    return await _loginRepo.SendVerificationEmail(email);
  }


}
class SendResetPasswordEmailUseCase extends UseCase<Unit, String>{
  final AuthRepo _loginRepo;

  SendResetPasswordEmailUseCase(this._loginRepo);
  @override
  Future<Either<Failure, Unit>> call(String email) async {
    return await _loginRepo.SendResetPasswordEmail(email);
  }

}
class CheckOtpUseCase extends UseCase<bool, String>{
  final AuthRepo _loginRepo;

  CheckOtpUseCase(this._loginRepo);
  @override
  Future<Either<Failure, bool>> call(String otp) async {
    return await _loginRepo.checkOtp(otp);
  }

}
class GoogleSignUseCase extends UseCase<User?, NoParams>{
  final AuthRepo _loginRepo;

  GoogleSignUseCase(this._loginRepo);
  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await _loginRepo.signinWithGoogle();
  }

}class GoogleRegisterUseCase extends UseCase<Unit, Member>{
  final AuthRepo _loginRepo;

  GoogleRegisterUseCase(this._loginRepo);
  @override
  Future<Either<Failure, Unit>> call(Member params) async {
    return await _loginRepo.RegisterInWithGoogle(params);
  }

}
