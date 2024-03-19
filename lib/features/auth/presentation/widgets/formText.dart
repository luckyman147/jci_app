import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
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
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter some text'.tr(context);
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          controller: controller,
textInputAction: TextInputAction.next,
          style: PoppinsRegular(16, textColorBlack,),
          key:Key(inputkey),
          //const Key('SignUpForm_EmailInput_textField'),
          onChanged: (value) => Onchanged(value),
          decoration:decorationTextField(errorText)
        );

  }
}
class FormTextPassword extends StatelessWidget {

  final String? errortext;
final TextEditingController controller ;
  final Function(String) Onchanged  ;
  final Function(String) validator  ;
  final String inputkey;

  const FormTextPassword({Key? key, required this.inputkey, required this.Onchanged,required this.errortext, required this.controller, required this.validator, }) : super(key: key);

  @override
  Widget build(BuildContext context) {

        return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
  builder: (context, state) {
    return TextFormField(
          style: PoppinsRegular(16, textColorBlack,),
      textInputAction: TextInputAction.done,
controller: controller,
enableSuggestions: false,
 validator: (value) {
  if (value!.isEmpty) {
    return 'Password Empty'.tr (context);
    
  }
  return null;
},

          key: Key(inputkey),

          onChanged: (password) {

            Onchanged(password);},
          obscureText: state.value,
          decoration: InputDecoration(

            enabledBorder: border(textColorBlack) ,
            focusedBorder: border(PrimaryColor),
            focusedErrorBorder: border(Colors.red),
            errorBorder: border(Colors.red),
            errorStyle: ErrorStyle(18, Colors.red),
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
}class FormTextConPassword extends StatelessWidget {

  final String? errortext;
final TextEditingController controller ;
  final Function(String) Onchanged  ;
  final String validator  ;
  final String inputkey;

  const FormTextConPassword({Key? key, required this.inputkey, required this.Onchanged,required this.errortext, required this.controller, required this.validator, }) : super(key: key);

  @override
  Widget build(BuildContext context) {

        return BlocBuilder<ToggleBooleanBloc, ToggleBooleanState>(
  builder: (context, state) {
    return TextFormField(
      enableSuggestions: false,
          style: PoppinsRegular(16, textColorBlack,),
      textInputAction: TextInputAction.done,
controller: controller,
validator:

    (value) {
  if (value!.isEmpty) {
    return 'Password Empty'.tr(context);
  }
  if (value != validator) {
    return 'Passwords do not match';
  }
  return null;
},
          key: Key(inputkey),
          onChanged: (password) {

            Onchanged(password);},
          obscureText: state.value,
          decoration: InputDecoration(

            enabledBorder: border(textColorBlack) ,
            focusedBorder: border(PrimaryColor),
            focusedErrorBorder: border(Colors.red),
            errorBorder: border(Colors.red),
            errorStyle: ErrorStyle(18, Colors.red),
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