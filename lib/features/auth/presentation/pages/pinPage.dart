
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import 'package:jci_app/features/auth/presentation/widgets/Components.dart';

import 'package:jci_app/features/auth/presentation/widgets/Inputs/PinForm.dart';
import 'package:jci_app/features/auth/presentation/widgets/SubmitFunctions.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../domain/entities/Member.dart';

import '../widgets/Text.dart';

class Pincode extends StatefulWidget {
final Member? member;
final String?email;
final VerifyEvent verifyEvent;
  const Pincode({Key? key, required this.member, required this.verifyEvent,required this.email}) : super(key: key);

  @override
  State<Pincode> createState() => _PincodeState();
}

class _PincodeState extends State<Pincode> {

  final formKey = GlobalKey<FormState>();
  final _controller1 = TextEditingController();
@override
  void initState() {
  context.read<ToggleBooleanBloc>().add(const ChangeIscompleted(isCompleted: false));
  context.read<ToggleBooleanBloc>().add(const ChangeIsEnabled(isEnabled: true));

    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller1.dispose();

  }
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaquery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text ('Verification Code'.tr(context), style: PoppinsSemiBold(16, textColorBlack,TextDecoration.none),),
      ),
      body: Center(
        child: BlocListener<SignUpBloc, SignUpState>(
  listener: (context, state) {
    if (state.signUpStatus==SignUpStatus.MessageSignUp){
      SnackBarMessage.showSuccessSnackBar(
          message: state.message, context: context);
      context.go('/login');
    }
    // TODO: implement listener}
  },
  child: BlocListener<ResetBloc, ResetPasswordState>(
  listener: (context, state) {
   SubmitFunctions. Listener(state, context,widget.email);
    // TODO: implement listener}
  },
  child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,

          children:[


        SizedBox(
            width: mediaquery.size.width/1.32,

            child: Text ('We have sent the verification code. Please check your inbox.'.tr(context), style: PoppinsLight(mediaquery.size.width/22, ThirdColor),)),
        AuthComponents.    TimerWidget(context,widget.email??'',widget.verifyEvent,(){
          SubmitFunctions.    Resendemail(context,widget.email,widget.verifyEvent);

        }),
            BuildForm(mediaquery, context),


       AuthComponents.     buildButtonPin(mediaquery,_controller1,formKey,widget.verifyEvent,widget.member),


          ]
        ),
),
),
      ),
    );
  }







  Widget BuildForm(MediaQueryData mediaquery, BuildContext context) {
    return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
  builder: (context, state) {
    return SizedBox(
            width: mediaquery.size.width/1.32,

            child: Column(
              children: [
                SizedBox(
                  width: mediaquery.size.width/1.32,

                  child: Padding(
                    padding: EdgeInsets.only(top: mediaquery.size.height /22,left: 8 ),
                    child: Align(
                        alignment:    Alignment.topLeft,
                        child: Label(text: "Pincode".tr(context), size: 21)),
                  ),
                ),
                PinForm(controller1: _controller1,size:mediaquery.size.width/4, formKey:formKey, isenabled: state.isEnbled,),
              ],
            ),
          );
  },
);
  }





}
