import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';


import '../../../../core/app_theme.dart';


class FormText extends StatelessWidget {
 final String? errorText;
  final TextEditingController controller ;

  final Function(String) Onchanged  ;
  final String inputkey;
  const FormText({Key? key, required this.inputkey, required this.Onchanged,  required this.errorText, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {

        return TextFormField(
          controller: controller,
textInputAction: TextInputAction.next,
          style: PoppinsRegular(18, textColorBlack,),
          key:Key(inputkey),
          //const Key('SignUpForm_EmailInput_textField'),
          onChanged: (value) => Onchanged(value),
          decoration: InputDecoration(
            enabledBorder: border(textColorBlack) ,
            focusedBorder: border(PrimaryColor),
            errorBorder: border(Colors.red),
            focusedErrorBorder: border(Colors.red),
            errorStyle: ErrorStyle(12, Colors.red),
          errorText:errorText

          ),
        );

  }
}
class FormTextPassword extends StatelessWidget {
  final String? errortext;
final TextEditingController controller ;
  final Function(String) Onchanged  ;
  final String inputkey;

  const FormTextPassword({Key? key, required this.inputkey, required this.Onchanged,required this.errortext, required this.controller, }) : super(key: key);

  @override
  Widget build(BuildContext context) {

        return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
  builder: (context, state) {
    return TextFormField(
          style: PoppinsRegular(18, textColorBlack,),
      textInputAction: TextInputAction.done,
controller: controller,
          key: Key(inputkey),
          onChanged: (password) {

            Onchanged(password);},
          obscureText: state.value,
          decoration: InputDecoration(

            enabledBorder: border(textColorBlack) ,
            focusedBorder: border(PrimaryColor),
            focusedErrorBorder: border(Colors.red),
            errorBorder: border(Colors.red),
            errorStyle: ErrorStyle(15, Colors.red),
            suffixIcon: IconButton(  onPressed: () {
                context.read<ToggleBooleanBloc>().add(ToggleBoolean());
            },
                icon:Icon(state.value ? Icons.visibility : Icons.visibility_off, color: textColorBlack,)),
            errorText:errortext
          ),
        );
  },
);

  }
}