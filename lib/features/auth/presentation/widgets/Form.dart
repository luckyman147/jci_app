



import 'dart:math';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/INPUTS/inputs_cubit.dart';

import '../../../../core/strings/Images.string.dart';
import '../../../../core/widgets/backbutton.dart';
import '../../AuthWidgetGlobal.dart';
import '../bloc/login/login_bloc.dart';
import 'Buttons/ButtonsComponents.dart';
import 'Buttons/SubmitButton.dart';
import 'Components/ForgetPasswordComponent.dart';
import 'Inputs/InputsWithLabels.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final randomNumber = Random().nextInt(2);
  

@override
  void initState() {
  context.read<LoginBloc>().add(HandleUserEmail());

  
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
final mediaquery = MediaQuery.of(context);

    return Column(



      children: [
        Backbutton(text:  "/Intro",onTap: (){
          context.read<InputsCubit>().resetInputs();
        },),
        BlocBuilder<InputsCubit, InputsState>(
      builder: (context, sta) {
     return BlocListener<LoginBloc, LoginState>(
  listener: (context, state) {
    if (state is GetUserEmailState){
      _emailController.text=state.emai;
    }
    // TODO: implement listener
  },
  child: Form(
          key: _key,
          child: Padding(
            padding:EdgeInsets.only(top: mediaquery.padding.top*1.2,bottom: mediaquery.padding.bottom*1.56),

            child: Center(
              child: BlocBuilder<LoginBloc, LoginState>(
  builder: (context, state) {
    return Column(
                mainAxisSize: MainAxisSize.min,
                 mainAxisAlignment: MainAxisAlignment.start,


                   children: [

                     TextWidget(text: "Sign In".tr(context), size: 33).animate(effects: [const FadeEffect()]),
                     Image.asset(randomNumber==0?images.hello:images.team,
                         width: 300.w, height: 280.h, fit: BoxFit.contain).animate(effects: [const FadeEffect()]),
                      LoginWithEmailButton(state: sta,),
                     EmailWithText(emailController: _emailController,  inputState: sta, onTap: (String ) {
                       context.read<LoginBloc>().add(LoginEmailnameChanged(String));
                     },),
                     //PhoneWithText(mediaquery: mediaquery,  state: state, inputState: sta, PhoneController: _PhoneController),

                     PassWordWithText( passwordController: _passwordController, inputState: sta, onTap: (String ) {
                       context.read<LoginBloc>().add(LoginPasswordChanged(String));
                     }, errorText: state.password.displayError != null ? "Invalid Password" : null, labelText: 'Password',),
                     ForgetPasswordWidget(state: sta,),



                     SubmitButton(  keyConr: _key, isInprogress: state is LoadingLoginWithEmail, onTap: () {
                       SubmitFunctions.Login(context, state, _key, () {
                         resetForm();
                       });
                     }, text: 'Login', state: sta ,),
                     Visibility(
                         visible:sta.inputsValue==Inputs.Email,
                         child: const Padding(padding: EdgeInsets.all(12))),
                     GoogleButton(state: state,),

                   //  const LoginWithPhoneButton(),


                     Padding(
                       padding: const EdgeInsets.only(top: 10),
                       child: DontHaveAccountWidget(mediaquery, context).animate(effects: [const FadeEffect()]),
                     )
                   ],
                 );
  },
),
            ),
          ),
        ),
);
      },
    ),
      ],
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
        context.read<InputsCubit>().ActivateEmail();
      },
      child: LinkedText(text: "SignUp".tr(context), size: mediaquery.size.width/30.5
      ),
    )
     ],
   );
  }

  void resetForm() {
    _key.currentState?.reset();
    _passwordController.clear();

  }




Widget line(double width)=> SizedBox(
width: width, // Set a fixed width for the Divider
child: const Divider(color:ThirdColor ,thickness: 1,height: 20,),
);

}