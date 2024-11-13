import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/INPUTS/inputs_cubit.dart';
import 'package:jci_app/features/auth/presentation/widgets/Inputs/InputsWithLabels.dart';

import '../../../AuthWidgetGlobal.dart';
import '../../bloc/login/login_bloc.dart';

class SubmitButton extends StatelessWidget {
  final GlobalKey<FormState> keyConr;
final bool isInprogress;
final Function() onTap;
final String text;
final InputsState state;


  const SubmitButton({
    Key? key,
    required this.keyConr, required this.isInprogress, required this.onTap, required this.text, required this.state,

  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return  Visibility(
          visible: state.inputsValue==Inputs.Email,
          child:

                   Padding(
                    padding:paddingSemetricVerticalHorizontal(h: 22),
                    child: Container(
                                    width: double.infinity,
                                    height: 66,
                                    decoration: BoxDecoration(
                    color: ColorsApp.PrimaryColor,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                        color: ColorsApp.textColorBlack, width: 2.0),
                                    ),
                                    child: InkWell(
                    onTap: () {
                      if (keyConr.currentState!.validate()) {
                        onTap();
                      }

                    },
                    child: Center(
                      child:
                      isInprogress?const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ):
                      Text(
                        text.tr(context),
                        style: PoppinsSemiBold(18, ColorsApp.textColorWhite,
                            TextDecoration.none),
                      ),
                    ),
                                    ),
                                  ),
                  ),


        ).animate(
          effects: [
           FadeEffect(duration: 500.milliseconds),
          ],
        );

  }
}
