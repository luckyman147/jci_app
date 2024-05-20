import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import 'package:jci_app/features/auth/presentation/widgets/SubmitFunctions.dart';
import 'package:jci_app/features/intro/presentation/bloc/internet/internet_bloc.dart';


import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';

import '../../../Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../bloc/login/login_bloc.dart';
import '../widgets/Form.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocListener<InternetCubit, InternetState>(

            listener: (context, state) {
         SubmitFunctions.     InternetListener(state, context);
            },
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
SubmitFunctions.LoginListener(state, context);
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
      ),
    );
  }



}