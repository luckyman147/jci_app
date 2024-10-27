import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';


import '../../../../core/app_theme.dart';
import '../../../../core/config/services/store.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../changelanguages/presentation/bloc/locale_cubit.dart';
import '../bloc/SignUp/sign_up_bloc.dart';
import '../bloc/bool/toggle_bool_bloc.dart';
import '../widgets/Text.dart';
import '../widgets/formText.dart';
import '../widgets/inputs.dart';

class ResetPassword extends StatefulWidget {

   ResetPassword({Key? key, required this.email}) : super(key: key);
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
  listener: (context, state)async{
    if(state.status== ResetPasswordStatus.error){

      SnackBarMessage.showErrorSnackBar(
          message: state.message, context: context);
    }
else if(state.status== ResetPasswordStatus. Updated){
      SnackBarMessage.showSuccessSnackBar(
          message: state.message, context: context);
      final islooged = await Store.isLoggedIn();
      if (!mounted) return;
      if (islooged) {
        context.go('/home');
      } else {
      context.go('/login');}
    }
    // TODO: implement listener
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
              child: Column(
                        children: [
              Align(
                alignment: Alignment.topLeft,
                child: Label(text: 'New Password'.tr(context), size: 20,),
              ),
              PasswordInputText(controller: Passwordcontroller),
                        SizedBox(height: 20,),
              Align(
                alignment: Alignment.topLeft,
                child: Label(text: 'Confirm Password'.tr(context), size: 20,),
              ),
              confirmpasswordText(controller: ConPasswordcontroller, PasswordContro: Passwordcontroller,),
                    Padding(
                      padding:  EdgeInsets.only(top: mediaquery.size.height *0.04),
                      child: _ResetButton(_key,widget.email),
                    )

                        ],


                      ),
            )

          ],),
        ),
    );
  },
),
    );
  }
  Widget _ResetButton (GlobalKey<FormState> key,String email   ){

    return BlocBuilder<ResetBloc, ResetPasswordState>(
      builder: (context, state) {
        return

          Container(
            width: double.infinity,
            height: 66,
            decoration: decoration,
            child: InkWell(

              onTap:
                  ()async {
                if (_key.currentState!.validate()){

final language=await context.read<localeCubit>().cachedLanguageCode();
                  final  Member member=Member(email: email, password: state.password.value, id: '', role: '', is_validated: false, cotisation: [], Images: [],teams: [], firstName: '', lastName: '', phone: '', IsSelected: false, Activities: [], points: 0, objectifs: [],language: language??'fr', rank: 0, description: '', board: "", PreviousPoints: 0);

                  context.read<ResetBloc>().add(ResetSubmitted( member: member));

                  //context.read<ResetBloc>().add(ResetPassForm());

                }

              },

              child:  Center(child: Text('Submit'.tr(context),style: PoppinsSemiBold(24, textColorWhite, TextDecoration.none) ,)),
            ),
          );
      },
    );}


}


