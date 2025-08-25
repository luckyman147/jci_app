import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Activity_Global.dart';
class PrefixIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;

  const PrefixIconButton({super.key, required this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
    );
  }
}
class StatusButton extends StatelessWidget {
  final bool Status;
  final Function() onPressed;
  final IconData isOn;
  final IconData isOff;
  final String textOn;
  final String textOff;
  final Color colorOn;
  final Color colorOff;
  final String labelText;

  const StatusButton({super.key, required this.Status, required this.onPressed,
    required this.isOn, required this.isOff,
    this.colorOff=Colors.green,
    required this.textOn, required this.textOff, required this.colorOn, required this.labelText});




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(h: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelText,
            style: PoppinsRegular(18, textColorBlack),
          ),
          ElevatedButton(
            onPressed: () {
              onPressed();
              // Add your functionality to toggle the visibility here if needed.
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Status ?colorOn : colorOff, // Green if public, Red if private
              ),
              //change raduis
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  side: const BorderSide(color: ColorsApp.textColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Status ? isOn : isOff,
                  color:textColorWhite, // White icon color
                ),
                const SizedBox(width: 8),
                Text(
                  Status ? textOn : textOff,
                  style: PoppinsSemiBold(18.sp , ColorsApp.textColorWhite, TextDecoration.none)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


