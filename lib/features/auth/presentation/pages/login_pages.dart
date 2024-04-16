import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import 'package:jci_app/features/intro/presentation/bloc/internet/internet_bloc.dart';


import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';

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
              if (state is NotConnectedState) {
              SnackBarMessage.showErrorSnackBar(
                  message: state.message.tr(context), context: context);
              } else if (state is ConnectedState) {
                SnackBarMessage.showSuccessSnackBar(
                    message: state.message.tr(context), context: context);
              }
            },
            child: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {

                if (state is MessageLogin) {
                  print('success' + state.message.toString());
                  SnackBarMessage.showSuccessSnackBar(
                      message: state.message, context: context);


                  context.go('/home');

                  context.read<PageIndexBloc>().add(SetIndexEvent(index:0));
                  context.read<MembersBloc>().add(GetUserProfileEvent(true));

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
      ),
    );
  }
}