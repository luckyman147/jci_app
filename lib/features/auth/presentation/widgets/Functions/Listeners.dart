import '../../../../../core/config/services/store.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../../../../Home/presentation/bloc/Activity/activity_cubit.dart';
import '../../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../../intro/presentation/bloc/internet/internet_bloc.dart';
import '../../../AuthWidgetGlobal.dart';
import '../../bloc/ResetPassword/reset_bloc.dart';
import '../../bloc/SignUp/sign_up_bloc.dart';
import '../../bloc/bool/toggle_bool_bloc.dart';
import '../../bloc/login/login_bloc.dart';

class ListenerSignUpFunctionsBlocs{
  static  void listenerBloc(SignUpState state, BuildContext context) {
    switch (state.signUpStatus) {
      case SignUpStatus.Loading:
      // Handle loading state if necessary
        break;

      case SignUpStatus.EmailSuccessState:
        SnackBarMessage.showSuccessSnackBar(message: state.message, context: context);

        break;

      case SignUpStatus.RegisterGoogle:
        SnackBarMessage.showSuccessSnackBar(message: state.message, context: context);
        context.go('/login');
        break;

      case SignUpStatus.ErrorSignUp:
        SnackBarMessage.showErrorSnackBar(message: state.message, context: context);
        context.read<SignUpBloc>().add( HandleErrorEvent());

        break;

      default:
      // Handle any other cases if necessary
        break;
    }
  }

}
class ListenerRestFunction{
  static   void Listener(ResetPasswordState state, BuildContext context,String? email)async {
    if (state.status == ResetPasswordStatus.error) {
      SnackBarMessage.showErrorSnackBar(
          message: state.message, context: context);
      context.read<ResetBloc>().add(const ResetErrorEvent());
    } else if (state.status == ResetPasswordStatus.Sended) {
      SnackBarMessage.showSuccessSnackBar(
          message: state.message, context: context);
      context.read<ToggleBooleanBloc>().add(const ChangeIsEnabled(isEnabled: true));

      //context.go('/reset/${widget.email}');
    }

    else if (state.status == ResetPasswordStatus.verified) {
      context.go('/reset/$email');
      context.read<ResetBloc>().add(const ResetErrorEvent());

    }
    else if (state.status == ResetPasswordStatus. Updated) {
      SnackBarMessage.showSuccessSnackBar(
          message: state.message, context: context);



        context.go('/home');

      context.read<ResetBloc>().add(const ResetErrorEvent());

    }


    }


}

class ListenerLoginFunctions{

  static   void LoginListener(LoginState state, BuildContext context) {


    if (state is MessageLogin) {

      SnackBarMessage.showSuccessSnackBar(
          message: state.message, context: context);


      context.go('/home');

      context.read<PageIndexBloc>().add(SetIndexEvent(index:0));

      context.read<MembersBloc>().add(const GetUserProfileEvent(true));
      context.read<AcivityFBloc>().add(const GetActivitiesOfMonthEvent(act:activity.Events));
    }
    else if (state is RegisterGoogle) {

      final name=state.user.displayName!.split(" ");
      //    context.read<SignUpBloc>().add(SignUpEmailnameChanged(state.user.email!));
      context.read<SignUpBloc>().add(FirstNameChanged(name[0]));
      context.read<SignUpBloc>().add(LastNameChanged(name[1]));
      context.go('/home');       }
    else if (state is ErrorLogin) {
      SnackBarMessage.showErrorSnackBar(
          message: state.message, context: context);
      context.read<LoginBloc>().add( HandleUserEvent());
    }


  }

}

class ListenerInternetFunctions{
  static
  void InternetListener(InternetState state, BuildContext context) {
    if (state is NotConnectedState) {
      SnackBarMessage.showErrorSnackBar(
          message: state.message.tr(context), context: context);
    } else if (state is ConnectedState) {
      SnackBarMessage.showSuccessSnackBar(
          message: state.message.tr(context), context: context);
    }
  }
}