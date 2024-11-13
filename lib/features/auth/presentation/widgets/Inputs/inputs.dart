import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../bloc/ResetPassword/reset_bloc.dart';
import '../../bloc/SignUp/sign_up_bloc.dart';

import 'formText.dart';

class PasswordInput  extends StatelessWidget {

  final TextEditingController controller;

  final Function(String) onTap;
  final String? errorText;
  final String inputkey;
  final Function(String) validator;
  const PasswordInput({super.key, required this.controller, required this.onTap, this.errorText, required this.inputkey, required this.validator,  });
  @override
  Widget build(BuildContext context) {
    return FormTextPassword(inputkey:
    inputkey,
      Onchanged: (password) {
       onTap(password);
      } ,
      errortext: errorText, controller: controller, validator: (String )
      {
        validator(String);

      },
    );
  }
}
class confirmpassword extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController PasswordContro;
  final Function(String) onTap;
  final String? errorText;


  const confirmpassword({super.key, required this.controller, required this.PasswordContro, required this.onTap, this.errorText});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return FormTextConPassword(inputkey: 'SignUpForm_confirmPasswordInput_textField',
          Onchanged: (confirmPassword) {
            onTap(confirmPassword);
          } ,
          errortext: errorText,


          controller: controller, validator: PasswordContro.text,


        );
      },
    );


  }
}
class firstname extends StatelessWidget {

  final TextEditingController controller;
  const firstname({super.key, required this.controller,});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.firstname != current.firstname,
      builder: (context, state) {

        return FormText( inputkey: 'SignUpFormfirstNameInput_textField',

          Onchanged:(firstname){
            print(firstname);
            context.read<SignUpBloc>().add(FirstNameChanged(firstname));},

          errorText:  state.firstname.displayError != null ?
          "Invalid first name"
              : null, controller:controller, hintText: 'First Name' ,

        );
      },);

  }
}

class lastname extends StatelessWidget {


  final TextEditingController controller;
  const lastname({super.key, required this.controller, });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.lastname != current.lastname,
      builder: (context, state) {
        return FormText(inputkey:  'SignUpFormLastNameInput_textField',
          Onchanged:
              (lastname){context.read<SignUpBloc>().add(LastNameChanged(lastname));},
          errorText: state.lastname.displayError != null ?
          "Invalid last name"
              : null, controller: controller, hintText: 'Last Name', );

      },  );
  }
}
// ! email inputs and phone input
class InputComponent extends StatelessWidget {
  final TextEditingController controller;

  final Function(String) onTap;
  final String? errorText;
  final String inputkey;
  final String hintText;

  const InputComponent({
    required this.controller,

    required this.onTap,
    required this.errorText,
    required this.inputkey, required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return FormText(
      inputkey: inputkey,
      Onchanged: (email) => onTap(email),
      errorText: errorText,
      controller: controller, hintText: hintText,
    );
  }


}


