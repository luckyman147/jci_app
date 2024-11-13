
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/app.dart';

import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/auth/domain/entities/AuthUser.dart';

import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import 'package:jci_app/features/auth/presentation/widgets/Buttons/PinButton.dart';
import 'package:jci_app/features/auth/presentation/widgets/Components/TimerComponent.dart';

import 'package:jci_app/features/auth/presentation/widgets/PinForm.dart';
import 'package:jci_app/features/auth/presentation/widgets/Functions/SubmitFunctions.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../../core/Member.dart';

import '../widgets/Functions/Listeners.dart';
import '../widgets/Text.dart';

class Pincode extends StatefulWidget {
final AuthUser? member;
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
  Widget build(BuildContext context) {
    final MediaQueryData mediaquery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
    ListenerRestFunction.Listener(state, context,widget.email);
    // TODO: implement listener}
  },
  child:
     Column(

          crossAxisAlignment: CrossAxisAlignment.center,

          children:[


        SizedBox(
            width: mediaquery.size.width/1.32,

            child: Text ('We have sent the verification code. Please check your inbox.'.tr(context), style: PoppinsLight(mediaquery.size.width/22, ThirdColor),)),
          Align(
            alignment: Alignment.topLeft,
            child: TimerWidget(email:
                widget.email??'',verifyEvent:  widget.verifyEvent,onPressed:  (){
            SubmitFunctions.    Resendemail(context,widget.email,widget.verifyEvent);

                    },),
          ),
            BuildForm(mediaquery, context),

        PinButton(mediaQuery: mediaquery,controller: _controller1, formKey: formKey,verifyEvent:  widget.verifyEvent,member:  widget.member, email: widget.email??"",),


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
            width: mediaquery.size.width / 1.32,

            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.32,

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
