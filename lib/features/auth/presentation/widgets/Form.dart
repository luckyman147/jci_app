


import 'package:flutter_animate/flutter_animate.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';
import 'package:jci_app/features/Teams/presentation/widgets/MembersTeamSelection.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/INPUTS/inputs_cubit.dart';
import 'package:jci_app/features/auth/presentation/widgets/button_auth.dart';


import '../../../../core/widgets/backbutton.dart';
import '../../AuthWidget..global.dart';
import '../bloc/login/login_bloc.dart';
import 'Buttons/ButtonsComponents.dart';
import 'Buttons/SubmitButton.dart';
import 'Inputs/formText.dart';
import 'Inputs/inputs.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  void resetform(){
    _key.currentState?.reset();

    _emailController.clear();
    _passwordController.clear();

  }

  @override
  Widget build(BuildContext context) {
final mediaquery = MediaQuery.of(context);

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {

   return  Column(



     children: [
       Backbutton(mediaquery, context, "/Intro"),
       BlocBuilder<InputsCubit, InputsState>(
  builder: (context, sta) {
    return Form(
         key: _key,
         child: Padding(
           padding:EdgeInsets.only(top: mediaquery.padding.top*2),

           child: Center(
             child: Column(
               mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,


                  children: [

                    TextWidget(text: "Sign In".tr(context), size: 33),
                    GoogleButton(state: state,),
                   const LoginWithEmailButton(),
                    const LoginWithPhoneButton(),
                    BlocBuilder<LoginBloc, LoginState>(
               builder: (context, state) {
                 return EmailWithText(mediaquery: mediaquery, emailController: _emailController, state: state, inputState: sta,);
               },
             ),
                    const Padding(padding: EdgeInsets.all(12)),
                    BlocBuilder<LoginBloc, LoginState>(
               builder: (context, state) {
                 return PassWordWithText(mediaquery: mediaquery, passwordController: _passwordController, state: state, inputState: sta,);
               },
             ),
                    LoginButton(  keyConr: _key ,),

                    DontHaveAccountWidget(mediaquery, context)
                  ],
                ),
           ),
         ),
       );
  },
),
     ],
   );}
    );
  }

  Row DontHaveAccountWidget(MediaQueryData mediaquery, BuildContext context) {
    return Row(
   mainAxisAlignment: MainAxisAlignment.center,
     children: [
    Text("Don't have an account?".tr(context),style:PoppinsLight( mediaquery.size.width/30.5, textColorBlack),),
    InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      radius: 10.0,
      borderRadius: BorderRadius.circular(10.0),
      onTap: (){
        context.go('/SignUp/${null}/${null}');
      },
      child: LinkedText(text: "SignUp".tr(context), size: mediaquery.size.width/30.5
      ),
    )
     ],
   );
  }


}

class PassWordWithText extends StatelessWidget {
  final LoginState state;
  final InputsState inputState;
  const PassWordWithText({
    super.key,
    required this.mediaquery,
    required TextEditingController passwordController, required this.state, required this.inputState,
  }) : _passwordController = passwordController;

  final MediaQueryData mediaquery;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: inputState.inputsValue !=Inputs.Google,
      child: Padding(
        padding: paddingSemetricHorizontal(h: 25),
        child: Column(
          children: [
            Align(
                alignment:    Alignment.topLeft,
                child: Label(text: "Password".tr(context), size: mediaquery.size.width/22.5)),
            PasswordInput(controller: _passwordController, onTap: (pass ) {
              context.read<LoginBloc>().add(LoginPasswordChanged(pass));

            }, inputkey: "sign up password",
              errorText: state.password.displayError != null ? "Invalid Password" : null,
              validator: (string ) {
            if(string.isEmpty) {
            return 'Empty';
            }
            if(string.length < 6) {
            return 'Too Short';
            }
            return null;
            },),
            Padding(
              padding: paddingSemetricAll(),
              child: Align(
              alignment:  Alignment.centerRight,
                  child: InkWell(
                    splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: (){
                        context.go('/forget');
                      },
                      child: LinkedText(text: "Forgot Password?".tr(context), size:  mediaquery.size.width/27.5))),
            ),
          ],
        ),
      ),
    ).animate();
  }
}

class EmailWithText extends StatelessWidget {
  final InputsState inputState;
  const EmailWithText({                      
    super.key,
    required this.mediaquery,
    required TextEditingController emailController, required this.state, required this.inputState,
  }) : _emailController = emailController;
final LoginState state;
  final MediaQueryData mediaquery;
  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: inputState.inputsValue == Inputs.Email,
      child: Padding(
        padding: paddingSemetricHorizontal(h: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment:    Alignment.topLeft,
                child: Label(text: "Email", size: mediaquery.size.width/22.5)),
            EmailInput(controller: _emailController, inputkey: "loginForm_emailInput_textField", onTap: (email) => context.read<LoginBloc>().add(LoginEmailnameChanged(email)),
              errorText: state.email.displayError != null ? "Invalid Email" : null,),
          ],
        ),
      ),
    );
  }
}






Widget line(double width)=> SizedBox(
width: width, // Set a fixed width for the Divider
child: const Divider(color:ThirdColor ,thickness: 1,height: 20,),
);