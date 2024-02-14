import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/widgets/backbutton.dart';
import '../bloc/login/login_bloc.dart';
import '../widgets/Text.dart';
import '../widgets/formText.dart';

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
                Backbutton(mediaquery, context, '/login'),
                Padding(
                  padding: EdgeInsets.only(bottom: mediaquery.size.height/20,top: mediaquery.size.height/5,right: mediaquery.size.width/10,left: mediaquery.size.width/10),
                  child: Column(
                    children: [
                      TextWidget(text: "reset  password".tr(context), size:mediaquery.size.width/11 ),
                   SizedBox(
                       width: mediaquery.size.width/1.32,
                       child: Text("send email".tr(context),style: PoppinsLight(mediaquery.size.width/23, ThirdColor )))
          
                    ],
                  ),
                ),
          
          
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mediaquery.size.width/10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                          alignment:    Alignment.topLeft,
                          child: Label(text: "Email", size: 22)),
                      _EmailInput(controller: _emailController,),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                _CheckButton(_key),
              ],
            ),
          ),
        )
    );

  }
  Widget _CheckButton  (
      GlobalKey<FormState> keyConr,
      ) {
    final MediaQueryData mediaquery = MediaQuery.of(context);
    return BlocBuilder<ResetBloc, ResetPasswordState>(
      builder: (context, state) {
        return

            Padding(
          padding: EdgeInsets.symmetric(horizontal: mediaquery.size.width/10),
              child: Container(

                        height: 66,
                        decoration: decoration,
                        child: InkWell(

              onTap: () {
                if (keyConr.currentState!.validate()) {
                  context.go('/pin/${state.email.value}');
                }
              //  if (keyConr.currentState!.validate()) {
                //  final member = LoginMember(email: state.email.value,
                  //  password: state.password.value,
                 // );


                  //context.read<LoginBloc>().add(LoginSubmitted(member));
                  //resetform();
                  //context.read<LoginBloc>().add(ResetForm());


              },

              child: Center(child: Text('Next'.tr(context),
                style: PoppinsSemiBold(24, textColorWhite, TextDecoration.none),)),
                        ),
                      ),
            );
      },
    );
  }

}
class _EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const _EmailInput({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetBloc, ResetPasswordState>(

      builder: (context, state) {
        print("${controller.text}");
        return FormText(inputkey: "ForgetForm_EmailInput_textField",
          Onchanged:
              (email) => context.read<ResetBloc>().add(EmailnameChanged(email)),

          errorText:  null, controller: controller,);
      },
    );
  }
}
