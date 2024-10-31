
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../changelanguages/presentation/bloc/locale_cubit.dart';
import '../../../intro/presentation/bloc/internet/internet_bloc.dart';
import '../../domain/entities/Member.dart';
import '../../domain/usecases/authusecase.dart';
import '../bloc/ResetPassword/reset_bloc.dart';
import '../bloc/bool/toggle_bool_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../pages/pinPage.dart';

class SubmitFunctions{
  static void SignUp(SignUpState state, GlobalKey<FormState> key, BuildContext context, void Function() resetform,bool isGoogle) async {
    if (key.currentState!.validate()) {
      final language=await context.read<localeCubit>().cachedLanguageCode();
      final member =
      Member.SignUp(state.email.value, state.password.value, state.firstname.value, state.lastname.value, language??'fr',"New Member" );

if (!isGoogle) {


  context.read<SignUpBloc>().add(SendVerificationEmailEventOrRegister(
      false, null, email: state.email.value));
  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      Pincode(member: member,
        verifyEvent: VerifyEvent.RegisterEvent,
        email: state.email.value,)));
}
else{
  context.read<SignUpBloc>().add(SendVerificationEmailEventOrRegister(
      true, member, email: state.email.value));

}
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
      context.read<LoginBloc>().add(const ResetFormLogin());

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
      context.go('/reset/$email');
    }
  }

  static   void Resendemail(BuildContext context,String? email,VerifyEvent verifyEvent) {
    context.go('/login');
  }
 static void SUbmitPin(ToggleBooleanState state, BuildContext context,VerifyEvent verifyEvent,TextEditingController controller1, GlobalKey<FormState> formKey, Member? member) {
   if (state.isCompleted){
    if (formKey.currentState!.validate()) {
      // Do something with the entered numbers

      if(verifyEvent==VerifyEvent.ResetPasswordEvent){
        context.read<ResetBloc>().add(CheckOtpEvent(otp: controller1.text));
}
      else{
        final sign=SignField(member: member, otp: controller1.text);
        context.read<SignUpBloc>().add(SignUpSubmitted(signField:sign));
      }}
  }}

  static
  void InternetListener(InternetState state, BuildContext context) {
    if (state is NotConnectedState) {
      SnackBarMessage.showErrorSnackBar(
          message: state.message.tr(context), context: context);
    } else if (state is ConnectedState) {
      SnackBarMessage.showSuccessSnackBar(
          message: state.message.tr(context), context: context);
    }
  }
  static   void LoginListener(LoginState state, BuildContext context) {


    if (state is MessageLogin) {

      SnackBarMessage.showSuccessSnackBar(
          message: state.message, context: context);


      context.go('/home');

      context.read<PageIndexBloc>().add(SetIndexEvent(index:0));

      context.read<MembersBloc>().add(const GetUserProfileEvent(true));
      context.read<AcivityFBloc>().add(const GetActivitiesOfMonthEvent(act:activity.Events));
    }
    else if (state is RegisterGoogle) {

      final name=state.user.displayName!.split(" ");
  //    context.read<SignUpBloc>().add(SignUpEmailnameChanged(state.user.email!));
      context.read<SignUpBloc>().add(FirstNameChanged(name[0]));
      context.read<SignUpBloc>().add(LastNameChanged(name[1]));
      context.go('/home');       }

  }

}