import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/INPUTS/inputs_cubit.dart';
import 'package:jci_app/features/auth/presentation/pages/pinPage.dart';
import 'package:jci_app/features/auth/presentation/widgets/Form.dart';
import 'package:jci_app/features/auth/presentation/widgets/Inputs/InputsWithLabels.dart';

import '../../../../core/app_theme.dart';

import '../../../../core/widgets/backbutton.dart';

import '../widgets/Buttons/CheckButton.dart';
import '../widgets/Inputs/formText.dart';
import '../widgets/Inputs/inputs.dart';
import '../widgets/Text.dart';


class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaquery = MediaQuery.of(context);
    return  Scaffold(
      body :
        SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                Backbutton( text: '/login', ),
                BuldForgetHeader(mediaquery: mediaquery),
                BuildEmailForgetPassword(mediaquery),
                const SizedBox(height: 30,),
                Checkbutton( keyConr: _key,),
              ],
            ),
          ),
        )
    );

  }

  Padding BuildEmailForgetPassword(MediaQueryData mediaquery) {
    return Padding(
                padding: EdgeInsets.symmetric(horizontal: mediaquery.size.width/10),
                child: BlocBuilder<ResetBloc, ResetPasswordState>(
                  builder: (context, state) {
                    return EmailWithText(emailController: _emailController, onTap: (email ) {
                  context.read<ResetBloc>().add(EmailnameChanged(email));
                }, errorText: state.email.displayError!=null?
                        "Invalid Email":null, inputState: InputsState()

                      ,);
                  },
                ),
              );
  }

}

class BuldForgetHeader extends StatelessWidget {
  const BuldForgetHeader({
    super.key,
    required this.mediaquery,
  });

  final MediaQueryData mediaquery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: mediaquery.size.height/20,top: mediaquery.size.height/14,right: mediaquery.size.width/10,left: mediaquery.size.width/10),
      child: Column(
        children: [
          TextWidget(text: "Reset Password".tr(context), size:mediaquery.size.width/11 ),
       SizedBox(
           width: mediaquery.size.width/1.32,
           child: Text("send email".tr(context),style: PoppinsLight(mediaquery.size.width/23, ThirdColor )))

        ],
      ),
    );
  }
}