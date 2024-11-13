
import 'package:flutter_animate/flutter_animate.dart';
import 'package:jci_app/features/auth/data/models/formz/lastname.dart';

import '../../../AuthWidgetGlobal.dart';
import '../../bloc/bool/INPUTS/inputs_cubit.dart';
import '../../bloc/login/login_bloc.dart';
import '../Components/ForgetPasswordComponent.dart';
import 'inputs.dart';

class PassWordWithText extends StatelessWidget {

  final InputsState inputState;
  final Function(String) onTap;
  final String? errorText;
  final String labelText;
  const PassWordWithText({
    super.key,

    required TextEditingController passwordController, required this.inputState, required this.onTap, required this.errorText, required this.labelText,
  }) : _passwordController = passwordController;


  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: inputState.inputsValue !=Inputs.Google,
      child: Padding(
        padding: paddingSemetricVerticalHorizontal(h: 25),
        child: Column(
          children: [

            HeaderLabel(text:  labelText.tr(context),),
            PasswordInput(controller: _passwordController, onTap: (pass ) {
onTap(pass);
            }, inputkey: "sign up password",
              errorText: errorText,
              validator: (string ) {
                if(string.isEmpty) {
                  return 'Empty';
                }
                if(string.length < 6) {
                  return 'Too Short';
                }
                return null;
              },),


          ],
        ).animate(
          effects: [
            FadeEffect(duration: 500.milliseconds),

          ],
        ),
      ),
    );
  }
}

class ComfirmPasswordWithText extends StatelessWidget {
  const ComfirmPasswordWithText({super.key, required this.controller, required this.PasswordContro, required this.onTap, this.errorText, required this.labelText});
  final TextEditingController controller;
  final TextEditingController PasswordContro;
  final Function(String) onTap;
  final String? errorText;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: paddingSemetricVerticalHorizontal(h: 25),
      child: Column(
        children: [
          HeaderLabel(text: "Confirm Password".tr(context)),
          confirmpassword(controller: controller, PasswordContro: PasswordContro, onTap: (confirmPassword) {
            onTap(confirmPassword);

          }, errorText: errorText),
        ],
      ).animate(
        effects: [
          FadeEffect(duration: 500.milliseconds),

        ],
      ),
    );

  }
}


class EmailWithText extends StatelessWidget {
  final InputsState inputState;
  final Function(String) onTap;
  final String? errorText;
  const EmailWithText({
    super.key,

    required TextEditingController emailController, required this.inputState, required this.onTap, this.errorText,
  }) : _emailController = emailController;


  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return Visibility(
      visible: inputState.inputsValue == Inputs.Email,
      child: Padding(
        padding: paddingSemetricVerticalHorizontal(h: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         HeaderLabel(text: "Email".tr(context)),
            InputComponent(controller: _emailController, inputkey: "emailInput_textField", onTap: (email) =>

              onTap(email),
              errorText: errorText, hintText: 'Email',),
          ],
        ),
      ),
    ).animate(
      effects: [
        FadeEffect(duration: 500.milliseconds),


      ],
    );
  }
}
/*
class PhoneWithText extends StatelessWidget {
  final InputsState inputState;
  const PhoneWithText({
    super.key,
    required this.mediaquery,
   r, required this.state, required this.inputState, required this.PhoneController,
  }) ;
  final LoginState state;
  final MediaQueryData mediaquery;
  final TextEditingController PhoneController;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: inputState.inputsValue == Inputs.Phone,
      child: Padding(
        padding: paddingSemetricHorizontal(h: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment:    Alignment.topLeft,
                child: Label(text: "Phone", size: mediaquery.size.width/22.5)),
            InputComponent(controller: PhoneController, inputkey: "loginForm_PHONEInput_textField", onTap: (phone) => context.read<LoginBloc>().add(LoginPhoneChanged(phone)),
              errorText: state.email.displayError != null ? "Invalid Phone" : null,),
          ],
        ),
      ),
    ).animate(
      effects: [
        FadeEffect(duration: 500.milliseconds),


      ],
    );
  }
}*/

class FirstNameWithLabel extends StatelessWidget {
  const FirstNameWithLabel({super.key, required this.firstnameController});
  final TextEditingController firstnameController ;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: paddingSemetricVerticalHorizontal(h: 25),
      child: Column(
        children: [
          HeaderLabel(text: "First Name".tr(context)),
          firstname(controller: firstnameController),
        ],
      ).animate(
        effects: [
          FadeEffect(duration: 500.milliseconds),

        ],
      ),
    );
  }
}class LastNameWithLabel extends StatelessWidget {
  const LastNameWithLabel({super.key, required this.lastnameController});
  final TextEditingController lastnameController ;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: paddingSemetricVerticalHorizontal(h: 25),
      child: Column(
        children: [
          HeaderLabel(text: "Last Name".tr(context)),
          firstname(controller: lastnameController),
        ],
      ).animate(
        effects: [
          FadeEffect(duration: 500.milliseconds),

        ],
      ),
    );
  }
}
