
import '../../../AuthWidget..global.dart';
import '../../bloc/ResetPassword/reset_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../pages/pinPage.dart';

class Checkbutton extends StatelessWidget {
  final GlobalKey<FormState> keyConr ;
  const Checkbutton({super.key, required this.keyConr});

  @override
  Widget build(BuildContext context) {
       final MediaQueryData mediaquery = MediaQuery.of(context);
    return BlocBuilder<ResetBloc, ResetPasswordState>(
      builder: (context, state)
       {
         return

           Padding(
             padding: EdgeInsets.symmetric(
                 horizontal: mediaquery.size.width / 10),
             child: Container(

               height: 66,
               decoration: decoration,
               child: InkWell(

                 onTap: () {
                   if (keyConr.currentState!.validate()) {
                     context.read<ResetBloc>().add(
                         sendResetPasswordEmailEvent(email: state.email.value));
                     Navigator.of(context).push(MaterialPageRoute(
                         builder: (context) =>
                             Pincode(
                               verifyEvent: VerifyEvent.ResetPasswordEvent,
                               member: null,
                               email: state.email.value,)));
                   }
                 },

                 child: Center(child: Text('Next'.tr(context),
                   style: PoppinsSemiBold(
                       24, textColorWhite, TextDecoration.none),)),
               ),
             ),
           );
       }
    );

  }
}

