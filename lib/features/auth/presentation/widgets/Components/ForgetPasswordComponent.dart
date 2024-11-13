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
        child: Align(
            alignment:  Alignment.centerRight,
            child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: (){
                  context.go('/forget');
                  context.read<InputsCubit>().ActivateEmail();
                  
                },
                child: LinkedText(text: "Forgot Password?".tr(context), size:  mediaquery.size.width/27.5))),
      ),
    ).animate(
      effects: [
        FadeEffect(duration: 500.milliseconds),

      ],
    );
  }
}