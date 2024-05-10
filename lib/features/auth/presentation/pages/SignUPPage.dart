import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/pages/pinPage.dart';
import 'package:jci_app/features/auth/presentation/widgets/SignUpForm.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';



import '../../domain/entities/Member.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/bool/toggle_bool_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../widgets/Form.dart';

class SignUpPage extends StatefulWidget {

final String? email;
final String? name;
  const SignUpPage({super.key, this.email, this.name});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    ToggleBooleanBloc toggleBooleanBloc = BlocProvider.of<ToggleBooleanBloc>(context);
    toggleBooleanBloc.add(ResetBoolean());
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state.signUpStatus ==SignUpStatus. Loading){

            }
            if (state.signUpStatus ==SignUpStatus. EmailSuccessState){
              SnackBarMessage.showSuccessSnackBar(message: state.message, context: context);

            }

            if (state.signUpStatus ==SignUpStatus. RegisterGoogle) {

SnackBarMessage.showSuccessSnackBar(message: state.message, context: context);
context.go('/login');
            }
            else if (state.signUpStatus ==SignUpStatus. ErrorSignUp) {

              SnackBarMessage.showErrorSnackBar(message: state.message, context: context);
            }


          },
          builder: (context, state) {
            if (state.signUpStatus ==SignUpStatus. Loading) {
              return const Align(
                  alignment: Alignment.center,
                  child: LoadingWidget());
            }
            return  SingleChildScrollView(
                child: SignUpForm(name: widget.name, gmail:  widget.email,)
            );
          },
        ),
      ),
    );
  }
}