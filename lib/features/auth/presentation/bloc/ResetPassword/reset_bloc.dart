

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/features/auth/domain/dtos/CheckOtopDtos.dart';
import 'package:jci_app/features/auth/domain/entities/AuthUser.dart';
import 'package:jci_app/features/auth/domain/usecases/authusecase.dart';



import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../data/models/formz/Email.dart';
import '../../../data/models/formz/cPassword.dart';
import '../../../data/models/formz/password.dart';
import '../../../domain/dtos/ResetpasswordDtos.dart';
import '../../../domain/usecases/UserAccountUsesCases.dart';


part 'reset_event.dart';
part 'reset_state.dart';

class ResetBloc extends Bloc<ResetEvent, ResetPasswordState> {
  ResetBloc(this.updatePasswordUseCase, this.checkOtpUseCase, this.sendResetPasswordEmailUseCase) : super( ResetPasswordState.initial()) {
    on<EmailnameChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirPasswordChanged>(_onCPasswordChanged);
    on <ResetPassForm>(_reset_form);
    on<ResetSubmitted>(_onSubmitted);
    on<CheckOtpEvent>(CheckOtp);
    on<sendResetPasswordEmailEvent>(SendResetPasswordEmail);

  }

void _resetError(ResetErrorEvent event, Emitter<ResetPasswordState> emit) {
  emit(state.copyWith(status: ResetPasswordStatus.initial));
}


final UpdatePasswordUseCase updatePasswordUseCase;
  final CheckOtpUseCase checkOtpUseCase;
  final SendResetPasswordEmailUseCase sendResetPasswordEmailUseCase;

  void SendResetPasswordEmail(sendResetPasswordEmailEvent event, Emitter<ResetPasswordState> emit) async {
try{
  emit(state.copyWith(status: ResetPasswordStatus.loading));
  final failureOrDoneMessage = await sendResetPasswordEmailUseCase.call(event.email);
  emit(_eitherSendedMessageOrErrorState(failureOrDoneMessage, 'Reset Password Email Sent Successfully'));

}catch(e){
  emit(state.copyWith(status: ResetPasswordStatus.error, message: e.toString()));
}
  }

  void CheckOtp(CheckOtpEvent event, Emitter<ResetPasswordState> emit) async {
    try{
      emit(state.copyWith(status: ResetPasswordStatus.loading));
      final failureOrDoneMessage = await checkOtpUseCase.call(event.checkOTPDtos);
      emit(_eitherVerifiedMessageOrErrorState(failureOrDoneMessage, 'OTP Verified Successfully'));
    }catch(e){
      emit(state.copyWith(status: ResetPasswordStatus.error, message: e.toString()));
}


  }


  void _reset_form(
      ResetPassForm  event,
      Emitter<ResetPasswordState> emit,
      ) {
    emit(
        ResetPasswordState.initial()
    );
  }
  void _onEmailChanged(
      EmailnameChanged event,
      Emitter<ResetPasswordState> emit,
      ) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
          isValid: state.password.isValid && state.email.isValid

//        isValid: Formz.validate([state.password, email]),
      ),
    );
  }
  void _onPasswordChanged(
      PasswordChanged event,
      Emitter<ResetPasswordState> emit,
      ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
          isValid: state.password.isValid && state.email.isValid

//        isValid: Formz.validate([password, state.email]),
      ),
    );
  }
  void _onCPasswordChanged(
      ConfirPasswordChanged event,
      Emitter<ResetPasswordState> emit,
      ) {
    final cpassword = ConfirmPassword.dirty(event.Confirmpassword);
    emit(
      state.copyWith(
        confirmPassword: cpassword,
        isValid: state.password.isValid && state.confirmPassword.isValid
      ),
    );
  }
  Future<void> _onSubmitted(
 ResetSubmitted event,
      Emitter<ResetPasswordState> emit,
      ) async {




        try {

          emit(state.copyWith(status: ResetPasswordStatus.loading));

          final failureOrDoneMessage = await updatePasswordUseCase(event.member);




          emit(_eitherDoneMessageOrErrorState(
              failureOrDoneMessage, 'Reset  Password Successfuly'));
          await Future.delayed(const Duration(seconds: 1));


        }
        catch (e) {
          state.copyWith(status: ResetPasswordStatus.error
            ,
            message: e.toString());


        }

    }

  ResetPasswordState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
          (failure) => state.copyWith(status: ResetPasswordStatus.error
            ,
        message: mapFailureToMessage(failure),
      ),
          (_) => state.copyWith(status: ResetPasswordStatus.Updated, message: message)
    );
  } ResetPasswordState _eitherSendedMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
          (failure) => state.copyWith(status: ResetPasswordStatus.error
            ,
        message: mapFailureToMessage(failure),
      ),
          (_) => state.copyWith(status: ResetPasswordStatus.Sended, message: message)
    );
  }

  ResetPasswordState _eitherVerifiedMessageOrErrorState(Either<Failure, Unit> failureOrDoneMessage, String s) {
    return failureOrDoneMessage.fold(
            (failure) => state.copyWith(status: ResetPasswordStatus.error
          ,
          message: mapFailureToMessage(failure)),
            (_) => state.copyWith(status: ResetPasswordStatus.verified, message: s)
    );
  }

}

