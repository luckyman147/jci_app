import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:jci_app/core/config/services/store.dart';



import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';

import '../../../../../core/usescases/usecase.dart';
import '../../../data/models/formz/Email.dart';
import '../../../data/models/formz/password.dart';
import '../../../domain/usecases/authusecase.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.loginUseCase,required this.googleSignUseCase})
      : super(const LoginState()) {
    on<LoginEmailnameChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);

    on<ResetFormLogin>(_reset_form);
    on<SignInWithGoogleEvent>(_onGoogleSign);
  }
final GoogleSignUseCase googleSignUseCase;
  final LoginUseCase loginUseCase;
  void _reset_form(
    ResetFormLogin event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginState.initial());
  }
void _onGoogleSign(
    SignInWithGoogleEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoadingLogin());
    final result = await googleSignUseCase.call(NoParams());
final status=await Store.getStatus();
    emit(_eithSignOrNTR(
        result, 'Login Successful',status));

    }
        catch (e) {
      log(e.toString());
        emit(ErrorLogin(message: "Something went wrong ${e.toString()}"));
        }
  }
  void _onEmailChanged(
    LoginEmailnameChanged event,
    Emitter<LoginState> emit,
  ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([state.password, email]),
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email]),
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {


      try {
        emit(LoadingLogin());
        final failureOrDoneMessage =
            await loginUseCase.LoginCredentials(event.email, event.password);



        emit(_eitherDoneMessageOrErrorState(
            failureOrDoneMessage, 'Login Successful'));


        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        emit(ErrorLogin(message: "Something went wrong ${e.toString()}"));
      }
  }



LoginState _eitherDoneMessageOrErrorState(
    Either<Failure, Unit> either, String message) {
  return either.fold(
    (failure) => ErrorLogin(
      message: mapFailureToMessage(failure),
    ),
    (_) => MessageLogin(message: message),
  );
}

  LoginState _eithSignOrNTR(Either<Failure, User?> result, String s, bool status) {
    return result.fold(
      (failure) => ErrorLogin(
        message: mapFailureToMessage(failure),
      ),
      (user) {
        if (user == null || status ) {
          return MessageLogin(message: "Login Successful");
        }
        else{
        return  RegisterGoogle(user: user );}
      }


    );

  }
}


