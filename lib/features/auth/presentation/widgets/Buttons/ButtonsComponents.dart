





import 'package:jci_app/features/auth/presentation/bloc/bool/INPUTS/inputs_cubit.dart';

import '../../../../../core/app_theme.dart';
import '../../../AuthWidget..global.dart';
import '../../bloc/login/login_bloc.dart';
import '../button_auth.dart';

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

          }, text: 'Login With Google'.tr(context), icon: FontAwesomeIcons.google,isLoading: state is LoadingLogin,),

          // authButton(onPressed: (){}, text: 'Login With Facebook'.tr(context), string: facebook),
        ],

      ),
    );
  }
}
class LoginWithEmailButton extends StatelessWidget {

  const LoginWithEmailButton({
key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(v: 18,h: 25),
      child: Column(

        children: [
          authButton(onPressed: (){


            context.read<InputsCubit>().ActivateEmail();

          }, text: "Login With Email".tr(context), icon: Icons.email,isLoading: false,),

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
            context.read<InputsCubit>().ActivatePhone();

          }, text: "Login With Phone".tr(context), icon: Icons.phone,isLoading: false,),

          // authButton(onPressed: (){}, text: 'Login With Facebook'.tr(context), string: facebook),
        ],

      ),
    );
  }
}

