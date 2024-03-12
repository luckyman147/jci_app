import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:formz/formz.dart';

import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';



import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';

import 'package:jci_app/features/auth/presentation/widgets/Text.dart';

import '../../../../core/widgets/backbutton.dart';


import '../../domain/entities/Member.dart';
import 'inputs.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _key = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

void _resetform(){
  _key.currentState?.reset();
  _firstnameController.clear();
  _lastnameController.clear();
  _emailController.clear();
  _passwordController.clear();
  _confirmPasswordController.clear();
}


  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
      Backbutton(mediaquery, context, '/login'),
        Align(
          alignment: Alignment.center,
          child: Padding(


              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextWidget(text: "Create Account".tr(context), size: mediaquery.size.width *0.08)),
        ),




        Form(
          key: _key,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      header("First Name".tr(context),mediaquery),
                      firstname(controller: _firstnameController, ),

                    ]),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    header("Last Name".tr(context),mediaquery),
                    lastname(controller: _lastnameController,),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    header("Email".tr(context),mediaquery),
                    UsernameInput(controller: _emailController,),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(8)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    header("Password".tr(context),mediaquery),
                    PasswordInput(controller: _passwordController,),

                  ],
                ),
              ),const Padding(padding: EdgeInsets.all(8)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    header("Confirm Password".tr(context),mediaquery),
                    confirmpassword(controller: _confirmPasswordController,PasswordContro: _passwordController,)

                  ],
                ),
              ),

              Padding(
                padding:  EdgeInsets.only(top:mediaquery.size.height/22,right: 25.0,left: 25,bottom: 12),
                child: _SignUpButton(
                ),
              ),

            ],
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mediaquery.size.width/60.5),
              child: Text("Already have an account?".tr(context),style:PoppinsLight( mediaquery.size.width/30.5, textColorBlack),),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: (){
                context.go('/login');
              },
              child: LinkedText(text: "Sign In".tr(context), size:  mediaquery.size.width/30.5,
              ),
            )
          ],
        )
      ],
    );
  }
Widget _SignUpButton (  ){

  return BlocBuilder<SignUpBloc, SignUpState>(
    builder: (context, state) {
      return
        state.status.isInProgress
            ? const CircularProgressIndicator():
        Container(
        width: double.infinity,
        height: 66,
        decoration: decoration,
        child: InkWell(

          onTap:
              () {


if (_key.currentState!.validate()) {
  final member =
Member(email: state.email.value,
  password: state.password.value,
  firstName: state.firstname.value,
  lastName: state.lastname.value, id: '', role: '', is_validated: false, cotisation: [false], Images: [], phone: '', IsSelected: false, Activities: [],  );

  context.read<SignUpBloc>().add(SignUpSubmitted(member: member));

  _resetform();
  context.read<SignUpBloc>().add(ResetForm());
  print('here  state status ${state.status}');
}
            },

          child:  Center(child: Text('SignUp'.tr(context),style: PoppinsSemiBold(24, textColorWhite, TextDecoration.none) ,)),
        ),
      );
    },
  );}

}
