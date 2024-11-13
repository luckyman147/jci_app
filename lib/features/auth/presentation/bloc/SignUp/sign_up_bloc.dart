import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';
import 'package:jci_app/core/strings/messages.dart';


import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../data/models/formz/Email.dart';
import '../../../data/models/formz/cPassword.dart';
import '../../../data/models/formz/firstname.dart';
import '../../../data/models/formz/lastname.dart';
import '../../../data/models/formz/password.dart';
import '../../../../../core/Member.dart';
import '../../../domain/dtos/SignInDtos.dart';
import '../../../domain/usecases/UserAccountUsesCases.dart';
import '../../../domain/usecases/authusecase.dart';



part 'sign_up_event.dart';
part 'sign_up_state.dart';


class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc( {

required  this.sendVerificationEmailUseCase,
    required this.signUpUseCase,


  })  :
        super( SignUpState.initial()) {
    on<SignUpEmailnameChanged>(_onEmailChanged);
    on<FirstNameChanged>(_onFirstnameChanged);
    on<LastNameChanged>(_onLastnameChanged);
    on<ConfirmPasswordChanged>(_onCPasswordChanged);

    on<SendVerificationEmailEventOrRegister>(_sendVerificationCode);

on <ResetForm>(_reset_form);
on <HandleErrorEvent>(_HandleError);


    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<RegisterWithEmailSubmitted>(_onSubmitted);
  }

  final SendVerifyCodeUseCases sendVerificationEmailUseCase;

final RegisterWithEmailUseCase signUpUseCase;


void _HandleError(HandleErrorEvent event, Emitter<SignUpState> emit) {
  emit (state.copyWith(signUpStatus: SignUpStatus.Initial));
}

  void _sendVerificationCode(SendVerificationEmailEventOrRegister event , Emitter<SignUpState> emit) async {

    try {
emit (state.copyWith(signUpStatus: SignUpStatus.Loading));
      final result = await sendVerificationEmailUseCase( event.email);
      emit(_eitherSentOrFailure(result, 'Verification Email Sent Successfully'));
      emit(state.copyWith(signUpStatus: SignUpStatus.Initial));

    } catch (e) {
      emit(state.copyWith(message: e.toString(),signUpStatus: SignUpStatus.ErrorSignUp),);
    }
  }

  SignUpState _eitherSentOrFailure(Either<Failure, Unit> result, String s) {
    return result.fold(
          (l) => state.copyWith(message: mapFailureToMessage(l),signUpStatus: SignUpStatus.ErrorSignUp),
          (r) => state.copyWith(signUpStatus: SignUpStatus.EmailSuccessState,message:s),
    );
  }
  void _onEmailChanged(
      SignUpEmailnameChanged  event,
      Emitter<SignUpState> emit,
      ) {
    final email = Email.dirty(event.email);


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
    debugPrint('ccpass is ${state.confirmPassword.isValid}.');

    emit(
      state.copyWith(
        confirmPassword: cpassword,
        isValid: state.password.isValid && state.email.isValid && state.firstname.isValid && state.lastname.isValid,
      ),
    );
  }



  Future<void> _onSubmitted(
      RegisterWithEmailSubmitted event,
      Emitter<SignUpState> emit,
      ) async {



          emit(state.copyWith(
        signUpStatus: SignUpStatus.Loading
            ,isLoading: true
          ));

            final failureOrDoneMessage = await signUpUseCase(
                event.signField);

            emit(_eitherDoneMessageOrErrorState(
                failureOrDoneMessage, SIGNUP_SUCCESS_MESS));
            emit(state.copyWith(
              signUpStatus: SignUpStatus.Initial
              ,isLoading: false
            ));





  }
  SignUpState _eitherDoneMessageOrErrorState(
      Either<Failure,  Unit> either, String message) {
    return either.fold(
          (failure) => state.copyWith(message: mapFailureToMessage(failure),signUpStatus: SignUpStatus.ErrorSignUp),
          (_) => state.copyWith(message: message,signUpStatus: SignUpStatus.MessageSignUp),
    );
  }

  SignUpState _eitherRegisterGoogle(Either<Failure, Unit> failureOrDoneMessage, String signupSuccessMess) {
    return failureOrDoneMessage.fold(
          (l) => state.copyWith(message: mapFailureToMessage(l),signUpStatus: SignUpStatus.ErrorSignUp),
          (r) => state.copyWith(message: signupSuccessMess,signUpStatus: SignUpStatus.RegisterGoogle),
    );
  }
}