import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_theme.dart';
import '../bloc/bool/toggle_bool_bloc.dart';

class PinForm extends StatelessWidget {
   PinForm({Key? key, required this.controller1, required this.formKey,  required this.size, required this.isenabled}) : super(key: key);
   final TextEditingController controller1 ;

  final GlobalKey<FormState> formKey ;
  final double size;
final bool isenabled ;
  void _saveForm() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // This triggers the onSaved callback

      // Do something with the saved data, for example, send it to a server

    }
  }
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Form(
        key: formKey,
        child:
      NumberInput(context,
          (String value) {
        if  (value.isEmpty){
          context.read<ToggleBooleanBloc>().add(ChangeIscompleted(isCompleted: false));

        }

        if (value.length == 6||value.length == 5) {
          context.read<ToggleBooleanBloc>().add(ChangeIscompleted(isCompleted: true));

            }
          }
      ,controller1,size,isenabled),),
    );
  }




  Widget NumberInput(BuildContext context,Function(String) onChanged,TextEditingController controller,double size,bool isenabled) {
    final MediaQueryData mediaquery = MediaQuery.of(context);
    return Container(
constraints: BoxConstraints(
  maxHeight: size,

minHeight: size,
),
      child: TextFormField(
enabled: isenabled,
         controller: controller,
        onChanged: (value) {
          onChanged(value);
        },


        validator: (value) {
          // Add validation logic here
          if (value == null || value.isEmpty) {
            return 'Field cannot be empty';
          }
          return null;
        },

        style: PoppinsRegular(18, textColorBlack,),
      keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(13),
          FilteringTextInputFormatter.digitsOnly,

        ],

        //const Key('SignUpForm_EmailInput_textField'),

        textAlign: TextAlign.center,
        decoration: InputDecoration(
      hintText: "X-X-X-X-X-X",
      hintStyle: PoppinsLight(18, ThirdColor),
            enabledBorder: border(PrimaryColor) ,
            focusedBorder: border(PrimaryColor),
            errorBorder: border(Colors.red),
            focusedErrorBorder: border(Colors.red),
            errorStyle: ErrorStyle(14, Colors.red),


        ),
      ),
    );
  }
}

