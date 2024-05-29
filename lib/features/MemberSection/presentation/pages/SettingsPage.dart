import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/SettingsComponents.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../../auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../bloc/Members/members_bloc.dart';

class SettingsPage extends StatefulWidget {
  final Member member;

  const SettingsPage({Key? key, required this.member}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conf = TextEditingController();

  @override
  void initState() {
    context.read<localeCubit>().getSavedLanguage();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordController.dispose();
    conf.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
        BackButton(
          onPressed: () {
            GoRouter.of(context).go('/home');
            context.read<MembersBloc>().add(GetUserProfileEvent(false));
          },


        ),

      ),
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState){
              context.go('/login');
            }
            // TODO: implement listener}
          },
          child: BlocListener<ResetBloc, ResetPasswordState>(
            listener: (context, state) {
              if (state.status == ResetPasswordStatus.Updated) {
                SnackBarMessage.showSuccessSnackBar(
                    message: state.message, context: context);
                context.go('/home');
                context.read<MembersBloc>().add(GetUserProfileEvent(false));
              }
              else if (state.status == ResetPasswordStatus.error) {
                SnackBarMessage.showErrorSnackBar(
                    message: state.message, context: context);
              }
              // TODO: implement listener}
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: paddingSemetricVerticalHorizontal(),
                    child: Text("Settings".tr(context), style: PoppinsSemiBold(
                        24, textColorBlack, TextDecoration.none),),
                  ),
                  SettingsComponent.ColumnActions(
                      context, widget.member, passwordController, conf,
                      _formKey),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
