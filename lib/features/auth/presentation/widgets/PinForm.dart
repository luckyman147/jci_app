import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_theme.dart';

class PinForm extends StatelessWidget {
   PinForm({Key? key, required this.controller1, required this.formKey, required this.controller2, required this.controller3, required this.controller4}) : super(key: key);
   final TextEditingController controller1 ;
   final TextEditingController controller2 ;
   final TextEditingController controller3 ;
   final TextEditingController controller4 ;
  final GlobalKey<FormState> formKey ;

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
      child: Form(child:
      Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        NumberInput(context,
            (String value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            }
        ,controller1),NumberInput(context,
            (String value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            }
        ,controller2),NumberInput(context,
            (String value) {
              if (value.length == 1) {
                FocusScope.of(context).nextFocus();
              }
            }
        ,controller3),NumberInput(context,
            (String value) {

            }
        ,controller4),

      ],),),
    );
  }




  SizedBox NumberInput(BuildContext context,Function(String) onChanged,TextEditingController controller) {
    return SizedBox(height: 60,
    width: 50,
      child: TextFormField(

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
        style: PoppinsRegular(32, textColorBlack,),
keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly
        ],
textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.center,
        //const Key('SignUpForm_EmailInput_textField'),

        decoration: InputDecoration(
            enabledBorder: border(textColorBlack) ,
            focusedBorder: border(PrimaryColor),
            errorBorder: border(Colors.red),
            focusedErrorBorder: border(Colors.red),
            errorStyle: ErrorStyle(18, Colors.red),


        ),
      ),
    );
  }
}
