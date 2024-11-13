
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/auth/domain/dtos/LoginWithEmailDto.dart';
import 'package:jci_app/features/auth/domain/dtos/SignInDtos.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/auth/presentation/widgets/Inputs/inputs.dart';

import '../../../../../core/util/snackbar_message.dart';
import '../../../../Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../../changelanguages/presentation/bloc/locale_cubit.dart';
import '../../../../intro/presentation/bloc/internet/internet_bloc.dart';
import '../../../../../core/Member.dart';
import '../../../domain/dtos/CheckOtopDtos.dart';
import '../../../domain/entities/AuthUser.dart';
import '../../../domain/usecases/authusecase.dart';
import '../../bloc/ResetPassword/reset_bloc.dart';
import '../../bloc/bool/toggle_bool_bloc.dart';
import '../../bloc/login/login_bloc.dart';
import '../../pages/pinPage.dart';

class SubmitFunctions{
  static void SignUp(SignUpState state, GlobalKey<FormState> key, BuildContext context, void Function() resetform) async {
    if (key.currentState!.validate()) {
      final language=await context.read<localeCubit>().cachedLanguageCode();
      final member =
      AuthUser.SignUp(email:state.email.value,password:  state.password.value,firstName:  state.firstname.value, lastName:state.lastname.value,language:  language??'fr');
  context.read<SignUpBloc>().add(SendVerificationEmailEventOrRegister(
      false, null, email: state.email.value));
  resetform();

   Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      Pincode(member: member,
        verifyEvent: VerifyEvent.RegisterEvent,
        email: state.email.value,)));



    }
  }
  static void Login(BuildContext context, LoginState state, GlobalKey<FormState> keyConr, void Function() resetform){
    if (keyConr.currentState!.validate()) {

final loginDtos=LoginWithEmailDtos(email: state.email.value, password: state.password.value);
      context.read<LoginBloc>().add(LoginWithEmailSubmitted(loginDtos));
      resetform();
      context.read<LoginBloc>().add(const ResetFormLogin());

    }
  }

  static   void Resendemail(BuildContext context,String? email,VerifyEvent verifyEvent) {
    context.read<SignUpBloc>().add(SendVerificationEmailEventOrRegister(
        false, null, email:email!));
  }
 static void SUbmitPin(ToggleBooleanState state, BuildContext context,VerifyEvent verifyEvent,TextEditingController controller1,
     GlobalKey<FormState> formKey, AuthUser? member,String email) {
   if (state.isCompleted){
    if (formKey.currentState!.validate()) {
      final sign=SignInDtos(member: member!, otp: controller1.text, email: email);

      // Do something with the entered numbers

      if(verifyEvent==VerifyEvent.ResetPasswordEvent){

        context.read<ResetBloc>().add(CheckOtpEvent(checkOTPDtos: controller1.text));
}
      else{
        context.read<SignUpBloc>().add(RegisterWithEmailSubmitted(signField:sign));
      }}
  }}


}

