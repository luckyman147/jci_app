import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:jci_app/features/auth/data/models/login/Email.dart';
import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';
import 'package:meta/meta.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../data/models/login/password.dart';

import '../../../domain/usecases/SIgnIn.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({ required this.loginUseCase })  :super(const LoginState()) {
    on<LoginEmailnameChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  on<ResetForm>(_reset_form);

  }

  final LoginUseCase loginUseCase;
  void _reset_form(
      ResetForm  event,
      Emitter<LoginState> emit,
      ) {
    emit(
        LoginState.initial()
    );
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
    if (state.isValid) {


        print('event'+ event.toString());

        if (event is LoginSubmitted){

          print('im here');
          final failureOrDoneMessage=await loginUseCase.LoginCredentials(event.loginMember);


          print( "login"+ failureOrDoneMessage.toString());

              emit( _eitherDoneMessageOrErrorState(failureOrDoneMessage, 'Login Successful'));
              await Future.delayed(const Duration(seconds: 1));


          emit(state.copyWith(status: FormzSubmissionStatus.success));

        }

      } else{
      if (!state.email.isValid) {
        emit(ErrorLogin(message: "Email is invalid"));
      }
      else if (!state.password.isValid) {
        emit(ErrorLogin(message: "Password is invalid"));
      }
      else {
        emit(ErrorLogin(message: "Something invalid"));
      }
      emit(const LoginState(status: FormzSubmissionStatus.canceled));
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

}
