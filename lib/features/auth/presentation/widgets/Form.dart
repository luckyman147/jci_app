import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/strings/svgs.dart';
import 'package:jci_app/features/auth/presentation/widgets/Text.dart';

import '../../../../core/util/snackbar_message.dart';
import '../bloc/login/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            SnackBarMessage.showErrorSnackBar(  message: 'Error', context:  context);
          }
        },
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

                      child: SvgPicture.string(pic)),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: TextWidget(text: "Login", size: 43),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment:    Alignment.topLeft,
                      child: Label(text: "Email", size: 22)),
                  _UsernameInput(),
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
                      child: Label(text: "Password", size: 22)),
                  _PasswordInput(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                    alignment:  Alignment.centerRight,
                        child: LinkedText(text: "Forgot Password?", size: 17)),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 25.0),
              child: _LoginButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          style: PoppinsNorml(20, textColorBlack,),
          key: const Key('loginForm_EmailInput_textField'),
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginEmailnameChanged(email)),
          decoration: InputDecoration(


enabledBorder: border(textColorBlack) ,
focusedBorder: border(PrimaryColor),
            focusedErrorBorder: border(Colors.red),
errorStyle: ErrorStyle(12, Colors.red),
            errorText:
            state.email.displayError != null ? 'Invalid Email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          style: PoppinsNorml(20, textColorBlack,),

          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) =>
              context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(

            enabledBorder: border(textColorBlack) ,
            focusedBorder: border(PrimaryColor),
focusedErrorBorder: border(Colors.red),
            errorStyle: ErrorStyle(15, Colors.red),
            suffixIcon: Icon(Icons.visibility_off,color: textColorBlack,),
            errorText:
            state.password.displayError != null ? 'Invalid Password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          ) ,
              child: ElevatedButton(








          key: const Key('loginForm_continue_raisedButton'),
          onPressed: state.isValid
                ? () {
              context.read<LoginBloc>().add(const LoginSubmitted());
          }
                : null,
          child:  Text('Login',style: PoppinsSemiBold(24, textColorWhite, TextDecoration.none) ,),
        ),
            );
      },
    );
  }
}