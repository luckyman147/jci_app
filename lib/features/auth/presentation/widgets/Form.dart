import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';
import 'package:jci_app/features/auth/presentation/widgets/Text.dart';
import 'package:jci_app/features/auth/presentation/widgets/button_auth.dart';
import 'package:jci_app/features/auth/presentation/widgets/formText.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/util/snackbar_message.dart';
import '../bloc/login/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  void resetform(){
    _key.currentState?.reset();

    _emailController.clear();
    _passwordController.clear();

  }

  @override
  Widget build(BuildContext context) {
final mediaquery = MediaQuery.of(context);

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        //if (state.status.isFailure) {
        //  SnackBarMessage.showErrorSnackBar(  message: 'Error', context:  context);
        //}

   return  Form(
     key: _key,
     child: Column(
           mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Align(
                alignment: Alignment.topLeft,
                child:Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11.0),
                  child: InkWell(
                      onTap: (){
                        context.go('/Intro');
                      },

                      child: SvgPicture.string(pic,width: 60,)),
                )),
            TextWidget(text: "Sign In".tr(context), size: 43),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment:    Alignment.topLeft,
                      child: Label(text: "Email", size: 22)),
                  _UsernameInput(controller: _emailController,),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(12)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Align(
                      alignment:    Alignment.topLeft,
                      child: Label(text: "Password".tr(context), size: 22)),
                  _PasswordInput(controller: _passwordController,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                    alignment:  Alignment.centerRight,
                        child: LinkedText(text: "Forgot Password?".tr(context), size: 17)),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 25.0),
              child: _LoginButton( _key, resetform,),
            ),
          divider(mediaquery),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 18.0),
              child: Column(

                children: [
                  authButton(onPressed: (){}, text: 'Login With Google'.tr(context), string: google),

                  authButton(onPressed: (){}, text: 'Login With Facebook'.tr(context), string: facebook),
                ],

              ),
            ),
     Row(
     mainAxisAlignment: MainAxisAlignment.center,
       children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaquery.size.width/60.5),
        child: Text("Don't have an account?".tr(context),style:PoppinsLight(17, textColorBlack),),
      ),
      InkWell(
        onTap: (){
          context.go('/SignUp');
        },
        child: LinkedText(text: "SignUp".tr(context), size: 17,
        ),
      )
       ],
     )
          ],
        ),
   );}
    );
  }
}

class _UsernameInput extends StatelessWidget {
  final TextEditingController controller;

  const _UsernameInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return FormText(inputkey: "loginForm_EmailInput_textField",
            Onchanged:
            (email) => context.read<LoginBloc>().add(LoginEmailnameChanged(email)),

            errorText:  state.  email.displayError!=null?"Invalid Email":null, controller: controller,);
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  final TextEditingController controller;

  const _PasswordInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return FormTextPassword(inputkey: "loginForm_passwordInput_textField",
            Onchanged: (password) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(password)),
            errortext:
           null, controller: controller, validator: (String ) {  },
        );}
    );
  }
}

Widget _LoginButton  (
   GlobalKey<FormState> keyConr,
   VoidCallback oncall) {
  return BlocBuilder<LoginBloc, LoginState>(
    builder: (context, state) {
      return state.status.isInProgress
          ? const CircularProgressIndicator()
          : Container(
        width: double.infinity,
        height: 66,
        decoration: BoxDecoration(
          color: PrimaryColor,

          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: textColorBlack, width: 2.0),
        ),
        child: InkWell(

          key: const Key('loginForm_continue_raisedButton'),
          onTap: () {

            if (keyConr.currentState!.validate()) {
              final member = LoginMember(email: state.email.value,
                password: state.password.value,
              );
              context.read<LoginBloc>().add(LoginSubmitted(member));

            }
          },

          child: Center(child: Text('Login'.tr(context),
            style: PoppinsSemiBold(24, textColorWhite, TextDecoration.none),)),
        ),
      );
    },
  );
}

Widget line(double width)=> SizedBox(
width: width, // Set a fixed width for the Divider
child: Divider(color:ThirdColor ,thickness: 1,height: 20,),
);