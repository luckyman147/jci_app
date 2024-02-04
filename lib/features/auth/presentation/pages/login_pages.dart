import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';

import '../../domain/repositories/Authentication.dart';
import '../bloc/login/login_bloc.dart';
import '../widgets/Form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: BlocProvider(
            create: (context) {
              return LoginBloc(
                authenticationRepository:
                RepositoryProvider.of<AuthenticationRepository>(context),
              );
            },
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}