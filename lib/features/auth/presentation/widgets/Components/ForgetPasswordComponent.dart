import 'package:auto_route/auto_route.dart';
import 'package:jci_app/core/route/app_router.dart';

import '../../../AuthWidgetGlobal.dart';
import '../../bloc/bool/INPUTS/inputs_cubit.dart';

class ForgetPasswordWidget extends StatelessWidget {
  const ForgetPasswordWidget({
    super.key, required this.state,

  });
final InputsState state;


  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return Visibility(
      visible: state.inputsValue !=Inputs.Google,
      child: Padding(
        padding: paddingSemetricAll(),
        child:  InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: (){
                  context.navigateTo(ForgetPasswordRoute());
                  context.read<InputsCubit>().ActivateEmail();
                  
                },
                child: LinkedText(text: "Forgot Password?".tr(context), size:  mediaquery.size.width/27.5))),

    ).animate(
      effects: [
        FadeEffect(duration: 500.milliseconds),

      ],
    );
  }
}