import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/widgets/SignUpForm.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';

import '../../domain/usecases/SignUp.dart';
import '../bloc/login/login_bloc.dart';
import '../widgets/Form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});


  @override
  Widget build(BuildContext context) {
    final SignUpUseCase signUpUseCase;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is MessageSignUp) {
              print('success'+ state.message.toString());
SnackBarMessage.showSuccessSnackBar(message: state.message, context: context);
context.go('/login');
            }
            else if (state is ErrorSignUp) {
              print('success'+ state.message.toString());

              SnackBarMessage.showErrorSnackBar(message: state.message, context: context);
            }
          },
          builder: (context, state) {
            if (state is LoadingSignUp) {
              return LoadingWidget();
            }
            return SingleChildScrollView(
                child: SignUpForm()
            );
          },
        ),
      ),
    );
  }
}