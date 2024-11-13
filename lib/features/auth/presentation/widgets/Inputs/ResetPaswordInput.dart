import '../../../AuthWidgetGlobal.dart';
import '../../bloc/ResetPassword/reset_bloc.dart';
import 'formText.dart';

class PasswordInputText extends StatelessWidget {
  final TextEditingController controller;


  const PasswordInputText({super.key, required this.controller,  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetBloc, ResetPasswordState>(

      builder: (context, state) {

        return FormTextPassword(inputkey:
        'ResetForm_passwordInput_textField',
          Onchanged: (password) {
            context.read<ResetBloc>().add(PasswordChanged(password));
          } ,
          errortext:  null, controller: controller, validator: (string ) {
            if(string.isEmpty) {
              return 'Empty'.tr(context);
            }
            if(string.length < 6) {
              return 'Too Short'.tr(context);
            }
            return null;
          },
        );
      },
    );
  }
}
class confirmpasswordText extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController PasswordContro;


  const confirmpasswordText(
      {super.key, required this.controller, required this.PasswordContro});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ResetBloc, ResetPasswordState>(
      builder: (context, state) {
        return FormTextConPassword(
            inputkey: 'ResetPasswordForm_confirmPasswordInput_textField',
            Onchanged: (confirmPassword) {
              context.read<ResetBloc>().add(
                  ConfirPasswordChanged(confirmPassword));
            },
            errortext: null,


            controller: controller,
            validator: PasswordContro.text


        );
      },
    );
  }
}




