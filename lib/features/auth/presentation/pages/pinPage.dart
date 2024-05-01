import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/presentation/bloc/ChangeString/change_string_bloc.dart';
import 'package:jci_app/features/auth/domain/usecases/authusecase.dart';
import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';

import 'package:jci_app/features/auth/presentation/widgets/PinForm.dart';
import 'package:jci_app/features/auth/presentation/widgets/SubmitFunctions.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/backbutton.dart';
import '../../domain/entities/Member.dart';
import '../bloc/SignUp/sign_up_bloc.dart';
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
  context.read<ToggleBooleanBloc>().add(ChangeIscompleted(isCompleted: false));
  context.read<ToggleBooleanBloc>().add(ChangeIsEnabled(isEnabled: true));

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
            TimerWidget(context),
            BuildForm(mediaquery, context),


            buildButtonPin(mediaquery),


          ]
        ),
),
      ),
    );
  }





  BlocBuilder<ToggleBooleanBloc, ToggleBooleanState> buildButtonPin(MediaQueryData mediaquery) {
    return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
builder: (context, state) {
  return SizedBox(
            width: mediaquery.size.width/1.32,

            child: InkWell(
              onTap:  () {
          SubmitFunctions.      SUbmitPin(state, context,widget.verifyEvent, _controller1,formKey,widget.member);
              },
              child: Container(
                width: double.infinity,
                height: 66,
                    decoration: BoxDecoration(
                      color: state.isCompleted? PrimaryColor:textColorWhite,

                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: textColorBlack, width: 2.0),
                    ),
                child:  Center(child: Text('Submit'.tr(context),style: PoppinsSemiBold(24, state.isCompleted?textColorWhite:textColor, TextDecoration.none) ,)),
              ),
            ),
          );
},
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

  Row TimerWidget(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CountdownTimer(
                endTime: DateTime.now().millisecondsSinceEpoch +100000, // Set end time for 5 minutes (300,000 milliseconds)
                widgetBuilder: (_,  time) {
                  if (time == null) {
                    context.read<ToggleBooleanBloc>().add(ChangeIscompleted(isCompleted: false));
                    context.read<ToggleBooleanBloc>().add(ChangeIsEnabled(isEnabled: false));
                    return TextButton(child: Text('Time Expired',style:
                      PoppinsSemiBold(15, Colors.red,TextDecoration.none)
                      ,), onPressed: () {
                  SubmitFunctions.    Resendemail(context,widget.email,widget.verifyEvent);

                    },); // Show 'Expired' when the countdown is finished
                  }
                  // Format remaining time to display
                  String formattedTime = '${time.min ?? 0}:${time.sec ?? 0}';
                  return Row(
                    children: [
                      Text('Time remaining:',
                      style: PoppinsRegular(18, textColor)

                      ),
                      SizedBox(width: 5,),
                      Text(formattedTime,
                      style: PoppinsRegular(18, PrimaryColor)
                      ),

                    ],
                  ); // Display remaining time
                },
              ),
            ],
          );
  }



}
