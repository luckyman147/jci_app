import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
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
        Form(
          key: _key,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child:Padding(
                    padding: EdgeInsets.symmetric(vertical:mediaquery.size.height/11),
                    child: InkWell(
                        onTap: (){
                          context.go('/login');
                        },

                        child: SvgPicture.string(pic,width: 60,)),
                  )),
              Padding(
                padding: EdgeInsets.only(bottom: mediaquery.size.width/10),
                child: TextWidget(text: "reset your password".tr(context), size:mediaquery.size.width/14 ),
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
        )
    );

  }
  Widget _CheckButton  (
      GlobalKey<FormState> keyConr,
      ) {
    final MediaQueryData mediaquery = MediaQuery.of(context);
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: mediaquery.size.width/10),
              child: Container(

                        height: 66,
                        decoration: BoxDecoration(
              color: PrimaryColor,

              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: textColorBlack, width: 2.0),
                        ),
                        child: InkWell(

              key: const Key('loginForm_continue_raisedButton'),
              onTap: () {
                context.go('/login');

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
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return FormText(inputkey: "ForgetForm_EmailInput_textField",
          Onchanged:(email){},
          //    (email) => context.read<LoginBloc>().add(LoginEmailnameChanged(email)),

          errorText:  state.  email.displayError!=null?"Invalid Email":null, controller: controller,);
      },
    );
  }
}
