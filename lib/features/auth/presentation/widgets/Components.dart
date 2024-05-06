import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../core/app_theme.dart';
import '../../domain/entities/Member.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/bool/toggle_bool_bloc.dart';
import 'SubmitFunctions.dart';

class AuthComponents{
  static Row TimerWidget(BuildContext context,String email,VerifyEvent verifyEvent,Function( ) onPressed) {
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
                onPressed();

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
static Widget NumberInput(BuildContext context,Function(String) onChanged,TextEditingController controller,double size,bool isenabled) {
  final MediaQueryData mediaquery = MediaQuery.of(context);
  return Container(
    constraints: BoxConstraints(
      maxHeight: size,

      minHeight: size,
    ),
    child: TextFormField(
      enabled: isenabled,
      controller: controller,
      onChanged: (value) {
        onChanged(value);
      },


      validator: (value) {
        // Add validation logic here
        if (value == null || value.isEmpty) {
          return 'Field cannot be empty';
        }
        return null;
      },

      style: PoppinsRegular(18, textColorBlack,),
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(6),
        FilteringTextInputFormatter.digitsOnly,

      ],

      //const Key('SignUpForm_EmailInput_textField'),

      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: "X-X-X-X-X-X",
        hintStyle: PoppinsLight(18, ThirdColor),
        enabledBorder: border(PrimaryColor) ,
        focusedBorder: border(PrimaryColor),
        errorBorder: border(Colors.red),
        focusedErrorBorder: border(Colors.red),
        errorStyle: ErrorStyle(14, Colors.red),


      ),
    ),
  );
}
  static BlocBuilder<ToggleBooleanBloc, ToggleBooleanState> buildButtonPin(MediaQueryData mediaquery,TextEditingController _controller1,GlobalKey<FormState> formKey,VerifyEvent verifyEvent,Member? member) {
    return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
      builder: (context, state) {
        return SizedBox(
          width: mediaquery.size.width/1.32,

          child: InkWell(
            onTap:  () {
              SubmitFunctions.      SUbmitPin(state, context,verifyEvent, _controller1,formKey,member);
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: state.isCompleted? PrimaryColor:textColorWhite,

                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: textColorBlack, width: 2.0),
              ),
              child:  Center(child: Text('Submit'.tr(context),style: PoppinsSemiBold(15, state.isCompleted?textColorWhite:textColor, TextDecoration.none) ,)),
            ),
          ),
        );
      },
    );
  }


}