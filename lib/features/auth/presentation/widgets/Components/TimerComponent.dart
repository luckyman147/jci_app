import 'package:flutter_countdown_timer/countdown_controller.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../AuthWidgetGlobal.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/bool/toggle_bool_bloc.dart';

class TimerWidget extends StatelessWidget {
  final String email;
  final VerifyEvent verifyEvent;
  final Function onPressed;


  const TimerWidget({
    Key? key,
    required this.email,
    required this.verifyEvent,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(h: 47.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CountdownTimer(

            endTime: DateTime.now().millisecondsSinceEpoch + 300000, // Set end time for 5 minutes (300,000 milliseconds)
            widgetBuilder: (_, time) {
              if (time == null) {
                context.read<ToggleBooleanBloc>().add(const ChangeIscompleted(isCompleted: false));
                context.read<ToggleBooleanBloc>().add(const ChangeIsEnabled(isEnabled: false));
                return TextButton(
                  child: Text(
                    'Time Expired',
                    style: PoppinsSemiBold(15, Colors.red, TextDecoration.none),
                  ),
                  onPressed: () {
                    onPressed();
                  },
                ); // Show 'Expired' when the countdown is finished
              }
              // Format remaining time to display
              String formattedTime = '${time.min ?? 0}:${time.sec ?? 0}';
              return Row(
                children: [
                  Text(
                    'Time remaining:',
                    style: PoppinsRegular(18, textColor),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    formattedTime,
                    style: PoppinsRegular(18, PrimaryColor),
                  ),
                ],
              ); // Display remaining time
            },
          ),
        ],
      ),
    );
  }
}