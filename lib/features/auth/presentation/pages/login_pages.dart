import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';

import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import 'package:jci_app/features/auth/presentation/widgets/Functions/SubmitFunctions.dart';
import 'package:jci_app/features/intro/presentation/bloc/internet/internet_bloc.dart';



import '../bloc/login/login_bloc.dart';
import '../widgets/Form.dart';
import '../widgets/Functions/Listeners.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        child: BlocListener<InternetCubit, InternetState>(

          listener: (context, state) {
            ListenerInternetFunctions.     InternetListener(state, context);
          },
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              ListenerLoginFunctions.LoginListener(state, context);
            },
            builder: (context, state) {

              return const SingleChildScrollView(
                  child: Center(child: LoginForm())
              );
            },
          ),
        ),
      ),
    );
  }



}