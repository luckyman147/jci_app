import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';


import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';

import '../bloc/login/login_bloc.dart';
import '../widgets/Form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is MessageLogin) {
                print('success' + state.message.toString());
                SnackBarMessage.showSuccessSnackBar(
                    message: state.message, context: context);

                context.go('/home');
              }
              else if (state is ErrorLogin) {
                print('success' + state.message.toString());

                SnackBarMessage.showErrorSnackBar(
                    message: state.message, context: context);
              }
            },
            builder: (context, state) {
              if (state is LoadingLogin) {
                return LoadingWidget();
              }
              return SingleChildScrollView(
                  child: LoginForm()
              );
            },
          ),
        ),
      ),
    );
  }
}