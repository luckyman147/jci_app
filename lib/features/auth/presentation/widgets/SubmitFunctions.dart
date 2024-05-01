import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../domain/entities/Member.dart';
import '../../domain/usecases/authusecase.dart';
import '../bloc/ResetPassword/reset_bloc.dart';
import '../bloc/bool/toggle_bool_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../pages/pinPage.dart';

class SubmitFunctions{
  static void SignUp(SignUpState state, GlobalKey<FormState> _key, BuildContext context, void Function() _resetform) {
    if (_key.currentState!.validate()) {
      final member =
      Member.SignUp(state.email.value, state.password.value, state.firstname.value, state.lastname.value,  );


      context.read<SignUpBloc>().add(SendVerificationEmailEvent(email:state.email.value));
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  Pincode(member: member, verifyEvent: VerifyEvent.RegisterEvent, email:state.email.value ,)));

      //
//Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  Pincode(member: member, verifyEvent: VerifyEvent.RegisterEvent,)));
    //  _resetform();
   //   context.read<SignUpBloc>().add(ResetForm());

    }
  }
  static void Login(BuildContext context, LoginState state, GlobalKey<FormState> keyConr, void Function() resetform){
    if (keyConr.currentState!.validate()) {


      context.read<LoginBloc>().add(LoginSubmitted(state.email.value, state.password.value));
      resetform();
      context.read<LoginBloc>().add(ResetFormLogin());

    }
  }
static   void Listener(ResetPasswordState state, BuildContext context,String? email) {
    if (state.status == ResetPasswordStatus.error) {
      SnackBarMessage.showErrorSnackBar(
          message: state.message, context: context);
    } else if (state.status == ResetPasswordStatus.Sended) {
      SnackBarMessage.showSuccessSnackBar(
          message: state.message, context: context);
      //context.go('/reset/${widget.email}');
    }
    else if (state.status == ResetPasswordStatus.verified) {
      context.go('/reset/${email}');
    }
  }

  static   void Resendemail(BuildContext context,String? email,VerifyEvent verifyEvent) {
    context.go('/login');
  }
 static void SUbmitPin(ToggleBooleanState state, BuildContext context,VerifyEvent verifyEvent,TextEditingController _controller1, GlobalKey<FormState> formKey, Member? member) {
   if (state.isCompleted){
    if (formKey.currentState!.validate()) {
      // Do something with the entered numbers

      if(verifyEvent==VerifyEvent.ResetPasswordEvent){
        context.read<ResetBloc>().add(CheckOtpEvent(otp: _controller1.text));
        ;}
      else{
        final sign=SignField(member: member, otp: _controller1.text);
        context.read<SignUpBloc>().add(SignUpSubmitted(signField:sign));
      }}
  }}
}