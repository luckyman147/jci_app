





import 'package:jci_app/features/auth/presentation/bloc/bool/INPUTS/inputs_cubit.dart';

import '../../../../../core/app_theme.dart';
import '../../../AuthWidgetGlobal.dart';
import '../../bloc/login/login_bloc.dart';
import 'button_auth.dart';

class GoogleButton extends StatelessWidget {
  final LoginState state;
  const GoogleButton({
    super.key, required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(v: 18,h: 25),
      child: Column(

        children: [
          authButton(onPressed: (){
            context.read<LoginBloc>().add(const SignInWithGoogleEvent());

          }, text: 'Login With Google'.tr(context), icon: FontAwesomeIcons.google,isLoading: state is LoadingLogin, isoogl: true,),

          // authButton(onPressed: (){}, text: 'Login With Facebook'.tr(context), string: facebook),
        ],

      ),
    );
  }
}
class LoginWithEmailButton extends StatelessWidget {
final InputsState state;
  const LoginWithEmailButton({
key, required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(v: 18,h: 25),
      child: Column(

        children: [
          authButton(onPressed: (){

            context.read<LoginBloc>().add(HandleUserEmail());
if (state.inputsValue==Inputs.Google) {
  context.read<InputsCubit>().ActivateEmail();
} else {
  context.read<InputsCubit>().resetInputs();
}

          }, text: "Login With Email".tr(context), icon: Icons.email,isLoading: false, isoogl: false,),

          // authButton(onPressed: (){}, text: 'Login With Facebook'.tr(context), string: facebook),
        ],

      ),
    );
  }
}
class LoginWithPhoneButton extends StatelessWidget {

  const LoginWithPhoneButton({
    key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(v: 18,h: 25),
      child: Column(

        children: [
          authButton(onPressed: (){
            //  context.read<LoginBloc>().add(const SignInWithGoogleEvent());


          }, text: "Login With Phone".tr(context), icon: Icons.phone,isLoading: false, isoogl: false,),

          // authButton(onPressed: (){}, text: 'Login With Facebook'.tr(context), string: facebook),
        ],

      ),
    );
  }
}

