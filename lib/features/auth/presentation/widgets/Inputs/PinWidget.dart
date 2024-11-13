import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../intro/presentation/widgets.global.dart';

class NumberInput extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController controller;
  final double size;
  final bool isEnabled;

  const NumberInput({
    Key? key,
    required this.onChanged,
    required this.controller,
    required this.size,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PinTheme defaultpinTheme=PinTheme(
      height: 53.h,
      width: 79.h,

      textStyle: PoppinsNorml(20.sp, ColorsApp.textColorBlack),
      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(
          color: ColorsApp.textColorBlack,
          width: 2,
        ),

        borderRadius: BorderRadius.circular(14),
      ),


    );
    final focusedPinTheme = defaultpinTheme.copyWith(
      decoration: defaultpinTheme.decoration!.copyWith(
        border: Border.all(
          color: ColorsApp.PrimaryColor,
          width: 2,
        ),
      ),
    );
    final disabled = defaultpinTheme.copyWith(
      decoration: defaultpinTheme.decoration!.copyWith(
        border: Border.all(
          color: ColorsApp.ThirdColor,
          width: 2,
        ),
      ),
    );
    return Container(
      constraints: BoxConstraints(
        maxHeight: size,
        minHeight: size,
      ),
      child: Pinput(
        length: 6, // Matches the number of characters
        // Hides entered PIN characters
        onChanged: (value) {
          // Handle PIN change events here
          onChanged(value); // Pass the value to your existing onChanged callback
        },
        focusedPinTheme: focusedPinTheme,
        defaultPinTheme: defaultpinTheme,
        disabledPinTheme: disabled,
        controller: controller,
        validator: (value) {
          // Optional validation logic
          if (value!.isEmpty) {
            return 'PIN cannot be empty';
          }
          return null;
        },
       // Adjust height based on your design
        mainAxisAlignment: MainAxisAlignment.center, // Center the PIN fields
        keyboardType: TextInputType.number,
        animationCurve: Curves.easeIn, // Customize animation behavior (optional)
        animationDuration: Duration(milliseconds: 200), // Customize animation duration (optional)
       enabled: isEnabled,
        // Additional customization options available!
      )
    );
  }
}
