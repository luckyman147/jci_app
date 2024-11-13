import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/features/auth/data/models/formz/PhoneNumber.dart';
import 'package:jci_app/features/auth/domain/dtos/LoginWithEmailDto.dart';



import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';

import '../../../../../core/usescases/usecase.dart';
import '../../../data/models/formz/Email.dart';
import '../../../data/models/formz/password.dart';
import '../../../domain/usecases/UserStatusUsesCases.dart';
import '../../../domain/usecases/authusecase.dart';


part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.loginWithEmailUseCase, this.getPreviousEmailUseCase, {required this.googleSignUseCase})
      : super(const LoginState()) {
    on<LoginEmailnameChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPhoneChanged>(_onPhoneChanged);
    on<LoginWithEmailSubmitted>(_onLoginWithEmailSubmitted);
    on<HandleUserEmail>(handleUserEmail);
    on<HandleUserEvent>(_handleuserEvent);
    on<ResetFormLogin>(_reset_form);
    on<SignInWithGoogleEvent>(_onGoogleSign);
  }
final GoogleSignUseCase googleSignUseCase;
  final GetPreviousEmailUseCase getPreviousEmailUseCase;
  final LoginWithEmailUseCase loginWithEmailUseCase;
  void handleUserEmail (
    HandleUserEmail event,
    Emitter<LoginState> emit,


      )async{
final result=await getPreviousEmailUseCase(NoParams());

result.fold(
        (l) => emit(ErrorLogin(message: mapFailureToMessage(l))),
        (r) => emit(GetUserEmailState(emai: r))
);
  }
  void _handleuserEvent(
    LoginEvent event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginState.initial());
  }
  void _reset_form(
    ResetFormLogin event,
    Emitter<LoginState> emit,
  ) {
    emit(LoadingLoginWithEmail());
  }
void _onGoogleSign(
    SignInWithGoogleEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(LoadingLogin());
    final result = await googleSignUseCase.call(NoParams());

    emit(_eithSignOrNTR(
        result, 'Login Successful',true));

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
  void _onPhoneChanged(
    LoginPhoneChanged event,
    Emitter<LoginState> emit,
  ) {
    final phone = PhoneNumber.dirty(event.phone);
    emit(
      state.copyWith(
        phone: phone,
        isValid: Formz.validate([state.password, state.email, phone]),
      ),
    );
  }


  Future<void> _onLoginWithEmailSubmitted(
      LoginWithEmailSubmitted event,
    Emitter<LoginState> emit,
  ) async {


      try {
 emit(LoadingLoginWithEmail());
        final failureOrDoneMessage =
            await loginWithEmailUseCase(event.loginWithEmailDtos);


debugPrint(failureOrDoneMessage.toString());
        emit(_eitherDoneMessageOrErrorState(
            failureOrDoneMessage, 'Login Successful'));



        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (e) {
        log(e.toString());
        emit(ErrorLogin(message: "${e.toString()}"));
      }
  }



LoginState _eitherDoneMessageOrErrorState(
    Either<Failure, Unit> either, String message) {
  return either.fold(
    (failure) => ErrorLogin(
      message: failure.toString(),
    ),
    (_) => MessageLogin(message: message),
  );
}

  LoginState _eithSignOrNTR(Either<Failure, Unit> result, String s, bool status) {
    return result.fold(
      (failure) => ErrorLogin(
        message: mapFailureToMessage(failure),
      ),
      (user) {

          return  MessageLogin(message: "Login Successful");


      }


    );

  }
}


