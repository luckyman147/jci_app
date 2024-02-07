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
import '../../../domain/usecases/Authentication.dart';
import '../../../domain/usecases/SIgnIn.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.loginUseCase, )  :
        super(const LoginState()) {
    on<LoginEmailnameChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final LoginUseCase loginUseCase;

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
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        print('event'+ event.toString());

        if (event is LoginSubmitted){
          print('im here');
          final failureOrDoneMessage=await loginUseCase.LoginCredentials(event.loginMember);


          print( "sign"+ failureOrDoneMessage.toString());

          emit(state.copyWith(status: FormzSubmissionStatus.success));

              emit( _eitherDoneMessageOrErrorState(failureOrDoneMessage, 'Login Successful'));

        }

      } catch (e) {
        print('yaatek asba'+e.toString());
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }


}
  LoginState _eitherDoneMessageOrErrorState(
      Either<Failure, Map> either, String message) {
    return either.fold(
          (failure) => ErrorLogin(
        message: mapFailureToMessage(failure),
      ),
          (_) => ErrorLogin(message: message),
    );
  }

}
