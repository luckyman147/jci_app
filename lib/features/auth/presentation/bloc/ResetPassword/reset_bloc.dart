

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:jci_app/features/auth/domain/usecases/authusecase.dart';



import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../data/models/formz/Email.dart';
import '../../../data/models/formz/cPassword.dart';
import '../../../data/models/formz/password.dart';


part 'reset_event.dart';
part 'reset_state.dart';

class ResetBloc extends Bloc<ResetEvent, ResetPasswordState> {
  ResetBloc(this.updatePasswordUseCase) : super( ResetPasswordState.initial()) {
    on<EmailnameChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirPasswordChanged>(_onCPasswordChanged);
    on <ResetPassForm>(_reset_form);
    on<ResetSubmitted>(_onSubmitted);

  }
final UpdatePasswordUseCase updatePasswordUseCase;
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
        isValid: state.password.isValid && state.email.isValid
      ),
    );
  }
  Future<void> _onSubmitted(
 ResetSubmitted event,
      Emitter<ResetPasswordState> emit,
      ) async {
    if (state.isValid) {
      print('event' + event.toString());

      if (event is ResetSubmitted) {
        try {

          print(' ya said im here');
          final failureOrDoneMessage = await updatePasswordUseCase.call(event.member);


          print("Reset" + failureOrDoneMessage.toString());

          emit(_eitherDoneMessageOrErrorState(
              failureOrDoneMessage, 'Reset  Password Successfuly'));
          await Future.delayed(const Duration(seconds: 1));


        }
        catch (e) {
          emit(ErrorReset(message: "Something went wrong ${e.toString()}"));

        }
      } else {
        if (!state.email.isValid) {
          emit(ErrorReset(message: "Email is invalid"));
        }
        else if (!state.password.isValid) {
          emit(ErrorReset(message: "Password is invalid"));
        }
        else {
          emit(ErrorReset(message: "Something invalid"));
        }

      }
    }
  }
  ResetPasswordState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
          (failure) => ErrorReset(
        message: mapFailureToMessage(failure),
      ),
          (_) => MessageReset(message: message),
    );
  }

}

