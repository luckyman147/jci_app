import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:formz/formz.dart';

import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';



import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/INPUTS/inputs_cubit.dart';
import 'package:jci_app/features/auth/presentation/widgets/Buttons/SubmitButton.dart';
import 'package:jci_app/features/auth/presentation/widgets/Functions/SubmitFunctions.dart';

import 'package:jci_app/features/auth/presentation/widgets/Text.dart';

import '../../../../core/widgets/backbutton.dart';


import 'Inputs/InputsWithLabels.dart';
import 'Inputs/inputs.dart';



class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key, required this.gmail, required this.name});
  final String? gmail;
  final String? name;

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
  void initState() {
  if (widget.gmail !="null" && widget.name != null) {
    _emailController.text = widget.gmail!;
    final name = widget.name!.split(' ');
    _firstnameController.text = name[0];
    _lastnameController.text = name[0];
  }
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
      Backbutton(text:  '/login'),
        Align(
          alignment: Alignment.center,
          child: Padding(


              padding: paddingSemetricHorizontal(h: 10),
              child: TextWidget(text: "Create Account".tr(context), size: mediaquery.size.width *0.08)),
        ),




        Form(
          key: _key,
          child: BlocBuilder<InputsCubit, InputsState>(
  builder: (context, sta) {
    return BlocBuilder<SignUpBloc , SignUpState>(
  builder: (context, state) {
    return Column(
            children: [
            FirstNameWithLabel(firstnameController: _firstnameController),

              LastNameWithLabel(lastnameController: _lastnameController),


              EmailWithText(emailController: _emailController, inputState: sta, onTap: (String ) {
                context.read<SignUpBloc>().add(SignUpEmailnameChanged(String));
              }, errorText: state.email.displayError != null ? "Invalid Email" : null

               ),


              PassWordWithText( passwordController: _passwordController, inputState: sta, onTap: (String ) {
                context.read<SignUpBloc>().add(SignUpPasswordChanged(String));
              }, errorText:
                state.password.displayError != null ? "Invalid Password" : null, labelText: 'Password'
                ,), Padding(padding: paddingSemetricAll()),


              ComfirmPasswordWithText( PasswordContro: _passwordController, onTap: (String ) {
context.read<SignUpBloc>().add(ConfirmPasswordChanged(String));
              }, errorText: state.confirmPassword.displayError != null ? "Invalid Password" : null, controller: _confirmPasswordController, labelText: 'Confirm Password',),

              SubmitButton(keyConr: _key, isInprogress: state.signUpStatus == SignUpStatus.Loading, onTap: () {
                SubmitFunctions.SignUp(state, _key, context, _resetform);}
                  ,text: 'SignUp', state: sta ,
              ),

            ],
          );
  },
);
  },
),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: paddingSemetricHorizontal(h:  mediaquery.size.width/60.5),
              child: Text("Already have an account?".tr(context),style:PoppinsLight( mediaquery.size.width/30.5, textColorBlack),),
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: (){
                context.go('/login');
                context.read<InputsCubit>().resetInputs();
              },
              child: LinkedText(text: "Sign In".tr(context), size:  mediaquery.size.width/30.5,
              ),
            )
          ],
        )
      ],
    );
  }
}
