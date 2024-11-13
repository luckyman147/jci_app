import '../../../AuthWidgetGlobal.dart';
import '../../../domain/entities/AuthUser.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/bool/toggle_bool_bloc.dart';
import '../Functions/SubmitFunctions.dart';

class PinButton extends StatelessWidget {
  final MediaQueryData mediaQuery;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final VerifyEvent verifyEvent;
  final AuthUser? member;
  final String email;

  const PinButton({
    Key? key,
    required this.mediaQuery,
    required this.controller,
    required this.formKey,
    required this.verifyEvent,
    this.member, required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
      builder: (context, state) {
        return SizedBox(
          width: mediaQuery.size.width / 1.32,
          child: InkWell(
            onTap: () {
              SubmitFunctions.SUbmitPin(state, context, verifyEvent, controller, formKey, member,email
              );
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: state.isCompleted ? PrimaryColor : textColorWhite,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: textColorBlack, width: 2.0),
              ),
              child: Center(
                child: Text(
                  'Submit'.tr(context),
                  style: PoppinsSemiBold(15, state.isCompleted ? textColorWhite : textColor, TextDecoration.none),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
