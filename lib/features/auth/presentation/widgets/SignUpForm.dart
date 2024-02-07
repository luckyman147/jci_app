import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
//import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/strings/svgs.dart';

import 'package:jci_app/features/auth/data/models/login/lastname.dart';
import 'package:jci_app/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/widgets/Text.dart';
import 'package:jci_app/features/auth/presentation/widgets/button_auth.dart';
import 'package:jci_app/features/auth/presentation/widgets/formText.dart';

//import '../../../../core/util/snackbar_message.dart';
import '../../data/models/login/Email.dart';
import '../../data/models/login/firstname.dart';
import '../../domain/entities/Member.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _key = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

void _resetform(){
  _key.currentState?.reset();
  _firstnameController.clear();
  _lastnameController.clear();
  _emailController.clear();
  _passwordController.clear();
  _confirmPasswordController.clear();
}


  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);


    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {


      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Align(
              alignment: Alignment.topLeft,
              child:Padding(
                padding: const EdgeInsets.symmetric(vertical: 11.0),
                child: InkWell(
                    onTap: (){
                      context.go('/login');
                    },

                    child: SvgPicture.string(pic)),
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(


                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextWidget(text: "Create an account", size: 33)),
          ),


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 18.0),
            child: Column(

              children: [
                authButton(onPressed: (){}, text: 'Sign Up With Google', string: google),

                authButton(onPressed: (){}, text: 'Sign Up With Facebook', string: facebook),
              ],

            ),
          ),     divider(mediaquery),

          Form(
            key: _key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        header("Firstname"),
                        _firstname(controller: _firstnameController, ),

                      ]),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      header("Last Name"),
                      _lastname(controller: _lastnameController,),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.all(8)),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      header("Email"),
                      _UsernameInput(controller: _emailController,),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      header("Password"),
                      _PasswordInput(controller: _passwordController,),

                    ],
                  ),
                ),const Padding(padding: EdgeInsets.all(8)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      header("Confirm Password"),
                      _confirmpassword(controller: _confirmPasswordController,),

                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 25.0),
                  child: _SignUpButton(
                  ),
                ),

              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mediaquery.size.width/60.5),
                child: Text("Already have an account?",style:PoppinsLight(18, textColorBlack),),
              ),
              InkWell(
                onTap: (){
                  context.go('/login');
                },
                child: LinkedText(text: "Sign In", size: 18,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
Widget _SignUpButton (  ){

  return BlocBuilder<SignUpBloc, SignUpState>(
    builder: (context, state) {
      return
        state.status.isInProgress
            ? const CircularProgressIndicator():
        Container(
        width: double.infinity,
        height: 66,
        decoration: BoxDecoration(
          color: PrimaryColor,

          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: textColorBlack, width: 2.0),
        ) ,
        child: InkWell(

          onTap:
              () {

              final member = MemberSignUp(email: state.email.value,
                password: state.password.value,
                FirstName: state.firstname.value,
                LastName: state.lastname.value,);
print(member);

              context.read<SignUpBloc>().add(SignUpSubmitted(member: member));
                print('here');
_resetform();
                context.read<SignUpBloc>().add(ResetForm());
                print('email reset' + state.email.value);
                print('password reset' + state.password.value);
   //           context.go('/login');
            },

          child:  Center(child: Text('SignUp',style: PoppinsSemiBold(24, textColorWhite, TextDecoration.none) ,)),
        ),
      );
    },
  );}

}
class _firstname extends StatelessWidget {

final TextEditingController controller;
  const _firstname({super.key, required this.controller,});


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
state.firstname.displayError!.name == FirstnameValidationError.tooLong
    ?'Too long '
    :  state.firstname.displayError!.name == FirstnameValidationError.tooShort? ' Too Short': null
    : null, controller:controller ,

);
      },);

  }
  }

class _lastname extends StatelessWidget {


  final TextEditingController controller;
  const _lastname({super.key, required this.controller, });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.lastname != current.lastname,
      builder: (context, state) {
        return FormText(inputkey:  'SignUpFormLastNameInput_textField',
            Onchanged:
            (_lastname){context.read<SignUpBloc>().add(LastNameChanged(_lastname));},
             errorText: state.lastname.displayError != null ?
          state.lastname.displayError!.name == LastnameValidationError.tooLong
              ?'Too long '
              :  state.lastname.displayError!.name == LastnameValidationError.tooShort? ' Too Short': null
              : null, controller: controller, );

      },  );
  }
}


class _UsernameInput extends StatelessWidget {
  final TextEditingController controller;


  const _UsernameInput({super.key, required this.controller, });
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
  builder: (context, state) {

    return FormText( inputkey: 'SignUpForm_EmailInput_textField',

      Onchanged:(email){context.read<SignUpBloc>().add(SignUpEmailnameChanged(email));},

        errorText: state.email.displayError != null ?
      state.email.displayError!.name == EmailValidationError.invalid
          ?'Invalid email address'
          :  state.email.displayError!.name == EmailValidationError.empty? 'Empty email': null
          : null, controller: controller,


    )
    ;
  },);

  }
}


class _PasswordInput extends StatelessWidget {
  final TextEditingController controller;


  const _PasswordInput({super.key, required this.controller,  });
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
            errortext:  state.passwordValidationErrorText?.text, controller: controller,
        );
      },
    );
  }
}
class _confirmpassword extends StatelessWidget {
final TextEditingController controller;

  const _confirmpassword({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.confirmPassword != current.confirmPassword ,
      builder: (context, state) {
        return FormTextPassword(inputkey: 'SignUpForm_confirmPasswordInput_textField',
            Onchanged: (confirmPassword) {
          print(state.confirmPassword.displayError);
              context.read<SignUpBloc>().add(ConfirmPasswordChanged(confirmPassword));
            } ,
         errortext:  state.confirmPassword.displayError != null ?

          "Password not matching":null, controller: controller,


        );
      },
    );
  }
}


Widget line(double width)=> SizedBox(
  width: width, // Set a fixed width for the Divider
  child: Divider(color:ThirdColor ,thickness: 1,height: 20,),
);