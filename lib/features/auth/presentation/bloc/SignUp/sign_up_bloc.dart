import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:jci_app/core/strings/messages.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import 'package:jci_app/features/auth/domain/usecases/SignUp.dart';


import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../data/models/login/Email.dart';
import '../../../data/models/login/cPassword.dart';
import '../../../data/models/login/firstname.dart';
import '../../../data/models/login/lastname.dart';
import '../../../data/models/login/password.dart';


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
    on<ConfirmPasswordChanged>(_onCPasswordChanged);



on <ResetForm>(_reset_form);

    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }


final SignUpUseCase signUpUseCase;
  void _onEmailChanged(
      SignUpEmailnameChanged  event,
      Emitter<SignUpState> emit,
      ) {
    final email = Email.dirty(event.email);

    print('email is $email.');
    print('pass is ${state.password.isValid}.');
    print('first is ${state.firstname.isValid}');
    print('last is ${state.firstname.isValid}');

    emit(
      state.copyWith(
        email: email,
        isValid: state.password.isValid && state.email.isValid && state.firstname.isValid && state.lastname.isValid,

//        isValid: Formz.validate([state.email,state.password,state.firstname,state.lastname,]
      ),
    );
  }
//reset forùm
void _reset_form(
      ResetForm  event,
      Emitter<SignUpState> emit,
      ) {
    emit(
   SignUpState.initial()
    );
  }

  void _onFirstnameChanged(
      FirstNameChanged  event,
      Emitter<SignUpState> emit,
      ) {
    final firstname = Firstname.dirty(event.firstName);
    print("firstname is $firstname");

    emit(
      state.copyWith(
        firstname: firstname,
        isValid: state.password.isValid && state.email.isValid && state.firstname.isValid && state.lastname.isValid,

        // isValid: Formz.validate([state.firstname, state.lastname,state.email,state.password]),
      ),
    );
  }
  void _onLastnameChanged(
      LastNameChanged  event,
      Emitter<SignUpState> emit,
      ) {

    final lastname = Lastname.dirty(event.lastName);
     print("lastname is $lastname");
    emit(
      state.copyWith(
        lastname: lastname,
        isValid: state.password.isValid && state.email.isValid && state.firstname.isValid && state.lastname.isValid,

        //isValid: Formz.validate([state.lastname,  state.firstname,state.email,state.password,) ),
      )    );
  }


  void _onPasswordChanged(
      SignUpPasswordChanged event,
      Emitter<SignUpState> emit,
      ) {

    final password = Password.dirty(event.password);
    print('pass is ${state.password.isValid}.');

    emit(
      state.copyWith(
        password: password,
        isValid: state.password.isValid && state.email.isValid && state.firstname.isValid && state.lastname.isValid,
      ),
    );
  }void _onCPasswordChanged(
      ConfirmPasswordChanged event,
      Emitter<SignUpState> emit,
      ) {
    final cpassword = ConfirmPassword.dirty(event.confirmPassword);
    emit(
      state.copyWith(
        confirmPassword: cpassword,
        isValid: state.password.isValid && state.email.isValid && state.firstname.isValid && state.lastname.isValid,
      ),
    );
  }



  Future<void> _onSubmitted(
      SignUpSubmitted event,
      Emitter<SignUpState> emit,
      ) async {

      if (event is SignUpSubmitted) {
   //     print("sqtatet ${state}");
     //   print("sqtatet ${state.isValid}");
        if (state.isValid) {
          emit(LoadingSignUp());
          final failureOrDoneMessage = await signUpUseCase.SignUpCred(
              event.member);
         print("sign" + failureOrDoneMessage.toString());

          emit(_eitherDoneMessageOrErrorState(
              failureOrDoneMessage, SIGNUP_SUCCESS_MESS));


          emit(const SignUpState(status: FormzSubmissionStatus.success));
        } else {

          if (!state.email.isValid) {
            emit(ErrorSignUp(message: "Email is invalid"));
          }
          else if (!state.password.isValid) {
            emit(ErrorSignUp(message: "Password is invalid"));
          }
          else if (!state.firstname.isValid) {
            emit(ErrorSignUp(message: "First name is invalid"));
          }
          else if (!state.lastname.isValid) {
            emit(ErrorSignUp(message: "Last name is invalid"));
          }
          else if (state.confirmPassword.value != state.password.value) {
            emit(ErrorSignUp(message: "Password does not match"));
          }
          else if (!state.confirmPassword.isValid) {
            emit(ErrorSignUp(message: "Password is invalid"));
          }
          else {
            emit(ErrorSignUp(message: "Something invalid"));
          }
          emit(const SignUpState(status: FormzSubmissionStatus.canceled));
        }

    }
  }
  SignUpState _eitherDoneMessageOrErrorState(
      Either<Failure,  Unit> either, String message) {
    return either.fold(
          (failure) => ErrorSignUp(
        message: mapFailureToMessage(failure),
      ),
          (_) => MessageSignUp(message: message),
    );
  }
}