import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/SignUp/sign_up_bloc.dart';
import 'formText.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;


  const PasswordInput({super.key, required this.controller,  });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return FormTextPassword(inputkey:
        'SignUpForm_passwordInput_textField',
          Onchanged: (password) {
            context.read<SignUpBloc>().add(SignUpPasswordChanged(password));
          } ,
          errortext:  null, controller: controller, validator: (String ) {
            if(String.isEmpty)
              return 'Empty';
            if(String.length < 6)
              return 'Too Short';
            return null;
          },
        );
      },
    );
  }
}
class confirmpassword extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController PasswordContro;


  const confirmpassword({super.key, required this.controller, required this.PasswordContro});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return FormTextConPassword(inputkey: 'SignUpForm_confirmPasswordInput_textField',
          Onchanged: (confirmPassword) {
            context.read<SignUpBloc>().add(ConfirmPasswordChanged(confirmPassword));

          } ,
          errortext: null,


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

          Onchanged:(_firstname){
            print(_firstname);
            context.read<SignUpBloc>().add(FirstNameChanged(_firstname));},

          errorText:  state.firstname.displayError != null ?
          "Invalid first name"
              : null, controller:controller ,

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
              (_lastname){context.read<SignUpBloc>().add(LastNameChanged(_lastname));},
          errorText: state.lastname.displayError != null ?
          "Invalid last name"
              : null, controller: controller, );

      },  );
  }
}


class UsernameInput extends StatelessWidget {
  final TextEditingController controller;


  const UsernameInput({super.key, required this.controller, });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {

        return FormText( inputkey: 'SignUpForm_EmailInput_textField',

          Onchanged:(email){context.read<SignUpBloc>().add(SignUpEmailnameChanged(email));},

          errorText: state.email.displayError != null ?
          "Invalid email": null,

          controller: controller,


        )
        ;
      },);

  }
}




