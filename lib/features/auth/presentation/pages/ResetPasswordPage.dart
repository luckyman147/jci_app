import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/features/auth/domain/entities/AuthUser.dart';
import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/INPUTS/inputs_cubit.dart';
import 'package:jci_app/features/auth/presentation/widgets/Buttons/SubmitButton.dart';


import '../../../../core/app_theme.dart';
import '../../../../core/config/services/store.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../changelanguages/presentation/bloc/locale_cubit.dart';
import '../../domain/dtos/ResetpasswordDtos.dart';
import '../bloc/bool/toggle_bool_bloc.dart';
import '../widgets/Functions/Listeners.dart';
import '../widgets/Inputs/InputsWithLabels.dart';
import '../widgets/Inputs/ResetPaswordInput.dart';
import '../widgets/Inputs/inputs.dart';
import '../widgets/Text.dart';


class ResetPassword extends StatefulWidget {

   const ResetPassword({Key? key, required this.email}) : super(key: key);
final String email;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  void initState() {
    ToggleBooleanBloc toggleBooleanBloc = BlocProvider.of<ToggleBooleanBloc>(context);
    toggleBooleanBloc.add(ResetBoolean());
    // TODO: implement initState
    super.initState();
  }
  final _key = GlobalKey<FormState>();
final Passwordcontroller=TextEditingController();

  final ConPasswordcontroller=TextEditingController();



  @override
  Widget build(BuildContext context) {
    final mediaquery=MediaQuery.of(context);

    return Scaffold(
      body: BlocConsumer<ResetBloc, ResetPasswordState>(
  listener: (context,state){
    ListenerRestFunction.Listener(state, context,widget.email);
  },
  builder: (context, state) {
    return Form(
      key: _key,
      child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Padding(
              padding: EdgeInsets.only(bottom:mediaquery.size.height*.05, right: mediaquery.size.width *0.01 ),
              child: SizedBox(
                  width: mediaquery.size.width/1.32,
                  child: TextWidget(text: "Reset Password".tr(context).toUpperCase(), size: 43)),
            ),
            Padding(

              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: BlocBuilder<InputsCubit, InputsState>(
  builder: (context, sta) {
    return Column(
                        children: [
            PassWordWithText(passwordController: Passwordcontroller, inputState: sta, onTap:(text){
              context.read<ResetBloc>().add(PasswordChanged(text));
            },
                errorText: state.password.displayError !=null?"Weak Password":null, labelText: "New Password"),
                          ComfirmPasswordWithText(controller: ConPasswordcontroller, PasswordContro: Passwordcontroller, onTap: (String ) {
                            context.read<ResetBloc>().add(ConfirPasswordChanged(String));
                            
                          }, labelText: 'Confirm Password',errorText: state.confirmPassword.displayError!=null?"Not Compatible":null,),
                   SubmitButton(keyConr: _key, isInprogress: state.status ==ResetPasswordStatus.loading, onTap: () {
final member=ResetpasswordDtos(email: widget.email, password: Passwordcontroller.text);
                     context.read<ResetBloc>().add(ResetSubmitted( member: member));
                     
                   }, text: 'Login', state: sta,)

                        ],


                      );
  },
),
            )

          ],),
        ),
    );
  },
),
    );
  }


}


