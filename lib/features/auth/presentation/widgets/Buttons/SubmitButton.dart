import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/INPUTS/inputs_cubit.dart';

import '../../../AuthWidget..global.dart';
import '../../bloc/login/login_bloc.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> keyConr;


  const LoginButton({
    Key? key,
    required this.keyConr,

  }) : super(key: key);

  void resetForm() {
    keyConr.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InputsCubit, InputsState>(
      builder: (context, sta) {
        return Visibility(
          visible: sta.inputsValue!=Inputs.Google,
          child: BlocBuilder<LoginBloc, LoginState>(

            builder: (context, state) {
              return state.status.isInProgress
                  ? const CircularProgressIndicator()
                  : Padding(
                    padding:paddingSemetricHorizontal(h: 22),
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
                      SubmitFunctions.Login(context, state, keyConr, () {
                        resetForm();
                      });
                    },
                    child: Center(
                      child: Text(
                        'Login'.tr(context),
                        style: PoppinsSemiBold(18, ColorsApp.textColorWhite,
                            TextDecoration.none),
                      ),
                    ),
                                    ),
                                  ),
                  );
            },
          ),
        );
      },
    );
  }
}
