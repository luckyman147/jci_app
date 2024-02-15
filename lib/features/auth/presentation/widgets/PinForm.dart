import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_theme.dart';

class PinForm extends StatelessWidget {
   PinForm({Key? key, required this.controller1, required this.formKey,  required this.size}) : super(key: key);
   final TextEditingController controller1 ;

  final GlobalKey<FormState> formKey ;
  final double size;

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
      NumberInput(context,
          (String value) {
            if (value.length == 9) {
              FocusScope.of(context).nextFocus();
            }
          }
      ,controller1,size),),
    );
  }




  SizedBox NumberInput(BuildContext context,Function(String) onChanged,TextEditingController controller,double size) {
    return SizedBox(height: 60,
    width: size,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
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
            LengthLimitingTextInputFormatter(9),
            FilteringTextInputFormatter.digitsOnly,
            CustomNumberFormatter()
          ],
        textAlignVertical: TextAlignVertical.center,
          textAlign: TextAlign.center,
          //const Key('SignUpForm_EmailInput_textField'),

          decoration: InputDecoration(
        hintText: "Enter 5 digits",

        hintStyle: PoppinsLight(27, ThirdColor),
              enabledBorder: border(PrimaryColor) ,
              focusedBorder: border(PrimaryColor),
              errorBorder: border(Colors.red),
              focusedErrorBorder: border(Colors.red),
              errorStyle: ErrorStyle(18, Colors.red),


          ),
        ),
      ),
    );
  }
}

class CustomNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Add a space after every character
    final newText = newValue.text.split('').join('-');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}