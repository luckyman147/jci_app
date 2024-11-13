import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jci_app/features/auth/domain/dtos/LoginWithEmailDto.dart';
import 'package:jci_app/features/auth/domain/dtos/LoginWithPhoneDto.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../dtos/SignInDtos.dart';
import '../repositories/AuthRepo.dart';




class SignOutUseCase extends UseCase<Unit, bool> {
  final AuthRepo authRepository;

  SignOutUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(bool params) async {
    return await authRepository.signOut(params);
  }
}


class LoginWithEmailUseCase  extends UseCase<Unit, LoginWithEmailDtos> {
final AuthRepo _loginRepo;

LoginWithEmailUseCase(this._loginRepo);


  Future<Either<Failure, Unit>> call(LoginWithEmailDtos login ) async {
    return await _loginRepo.logInWithEmail(login);
  }
}
class LoginWithPhoneUseCase  extends UseCase<Unit, LoginWithPhoneDtos> {
final AuthRepo _loginRepo;

LoginWithPhoneUseCase(this._loginRepo);


  Future<Either<Failure, Unit>> call(LoginWithPhoneDtos login ) async {
    return await _loginRepo.logInWithPhone(login);
  }
}

class RegisterWithEmailUseCase extends UseCase<Unit, SignInDtos> {
  final AuthRepo authRepository;

  RegisterWithEmailUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(SignInDtos signfield) async {
    return await authRepository.RegisterWithEmail(signfield);
  }

}



//register with phone
class SignUpWithPhoneUseCase extends UseCase<Unit, SignInDtos> {
  final AuthRepo authRepository;

  SignUpWithPhoneUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Unit>> call(SignInDtos signfield) async {
    return await authRepository.RegisterWithPhone(signfield);
  }

}



class GoogleSignUseCase extends UseCase<Unit, NoParams>{
  final AuthRepo _loginRepo;

  GoogleSignUseCase(this._loginRepo);
  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await _loginRepo.signInWithGoogle();
  }

}

