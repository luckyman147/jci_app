import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:jci_app/core/strings/messages.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import 'package:jci_app/features/auth/domain/usecases/SignUp.dart';


import '../../../../core/error/Failure.dart';
import '../../../../core/strings/failures.dart';
import '../../data/models/login/Email.dart';
import '../../data/models/login/cPassword.dart';
import '../../data/models/login/firstname.dart';
import '../../data/models/login/lastname.dart';
import '../../data/models/login/password.dart';
import '../../domain/usecases/Authentication.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';


class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc( {

    required this.signUpUseCase,

  })  :
        super( SignUpState.initial()) {
    on<SignUpEmailnameChanged>(_onEmailChanged);
    on<FirstNameChanged>(_onFirstnameChanged);
    on<LastNameChanged>(_onLastnameChanged);



on <ResetForm>(_reset_form);
    on<ConfirmPasswordChanged>(_onCPasswordChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }


final SignUpUseCase signUpUseCase;
  void _onEmailChanged(
      SignUpEmailnameChanged  event,
      Emitter<SignUpState> emit,
      ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([state.password, state.email,state.firstname,state.lastname,state.confirmPassword]
      ),
    ));
  }

  void _reset_form(
      ResetForm event,Emitter <SignUpState> emit
      ){
    emit(SignUpState.initial());
  }
  void _onFirstnameChanged(
      FirstNameChanged  event,
      Emitter<SignUpState> emit,
      ) {
    final firstname = Firstname.dirty(event.firstName);
    emit(
      state.copyWith(
        firstname: firstname,
        isValid: Formz.validate([state.firstname, state.lastname,state.email,state.password,state.confirmPassword]),
      ),
    );
  }
  void _onLastnameChanged(
      LastNameChanged  event,
      Emitter<SignUpState> emit,
      ) {

    final lastname = Lastname.dirty(event.lastName);
    emit(
      state.copyWith(
        lastname: lastname,
        isValid: Formz.validate([state.lastname,  state.firstname,state.email,state.password,state.confirmPassword]
     ) ),
    );
  }
  void _onCPasswordChanged(
      ConfirmPasswordChanged event,
      Emitter<SignUpState> emit,
      ) {
    final cpassword = ConfirmPassword.dirty(
password: state.password, value: event.confirmPassword
    );
    emit(
      state.copyWith(
        confirmPassword: cpassword,
        isValid: Formz.validate([cpassword, state.password, state.email, state.firstname, state.lastname]),
      ),
    );
  }

  void _onPasswordChanged(
      SignUpPasswordChanged event,
      Emitter<SignUpState> emit,
      ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email, state.firstname, state.lastname, state.confirmPassword]),
      ),
    );
  }



  Future<void> _onSubmitted(
      SignUpSubmitted event,
      Emitter<SignUpState> emit,
      ) async {


  try {
    emit(const SignUpState(status: FormzSubmissionStatus.inProgress ));

    if (event is SignUpSubmitted) {
      print('im here');

      emit(LoadingSignUp());
      final failureOrDoneMessage = await signUpUseCase.SignUpCred(
          event.member);
      print("sign" + failureOrDoneMessage.toString());

      emit(_eitherDoneMessageOrErrorState(
          failureOrDoneMessage, SIGNUP_SUCCESS_MESS));

      emit(const SignUpState(status: FormzSubmissionStatus.success));

    }

  } catch (e) {
    emit(const SignUpState(status: FormzSubmissionStatus.failure));
    print('yaatek asba' + e.toString());
  }
  }

  SignUpState _eitherDoneMessageOrErrorState(
      Either<Failure, String> either, String message) {
    return either.fold(
          (failure) => ErrorSignUp(
        message: mapFailureToMessage(failure),
      ),
          (_) => MessageSignUp(message: message),
    );
  }
}