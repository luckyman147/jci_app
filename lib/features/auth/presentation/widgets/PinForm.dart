import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bool/toggle_bool_bloc.dart';
import 'Inputs/PinWidget.dart';

class PinForm extends StatelessWidget {
   const PinForm({Key? key, required this.controller1, required this.formKey,  required this.size, required this.isenabled}) : super(key: key);
   final TextEditingController controller1 ;


  final GlobalKey<FormState> formKey ;
  final double size;
final bool isenabled ;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Form(
        key: formKey,
        child:
      NumberInput(onChanged:
          (String value) {
        if  (value.isEmpty || value.length < 6) {
          context.read<ToggleBooleanBloc>().add(const ChangeIscompleted(isCompleted: false));

        }

        if (value.length == 6) {
          context.read<ToggleBooleanBloc>().add(const ChangeIscompleted(isCompleted: true));

            }
          }
      , controller: controller1, size: size, isEnabled: isenabled,),),
    );
  }





}

