import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/auth/presentation/widgets/Components.dart';

import '../../bloc/bool/toggle_bool_bloc.dart';

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
  AuthComponents.    NumberInput(context,
          (String value) {
        if  (value.isEmpty){
          context.read<ToggleBooleanBloc>().add(const ChangeIscompleted(isCompleted: false));

        }

        if (value.length == 6||value.length == 5) {
          context.read<ToggleBooleanBloc>().add(const ChangeIscompleted(isCompleted: true));

            }
          }
      ,controller1,size,isenabled),),
    );
  }





}

