import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/app_theme.dart';
import '../../../Activity_Global.dart';

class Pinnedbutton extends StatelessWidget {
  final Function(Activity) onTap;
  final bool isPinned;
  final double? height;
  final Activity activity;
  const Pinnedbutton({super.key, required this.onTap, required this.isPinned, this.height, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: paddingSemetricHorizontal(),
      child: Container(
        height: 45.h,
        width: 45.h,
        decoration: BoxDecoration(
          border: Border.all(color: isPinned ? ColorsApp.SecondaryColor : ColorsApp.BackWidgetColor, width: 1),
          color: isPinned ? ColorsApp.SecondaryColor : ColorsApp.BackWidgetColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(

            onTap: onTap(activity),
            child: Icon(Icons.push_pin_rounded, color: isPinned ? ColorsApp.textColorWhite : ColorsApp.textColorBlack, ),
          ),
        ),
      ),).animate(
        effects: [
          const FadeEffect(
            duration: Duration(milliseconds: 500),
          )
        ]
    );
  }
}
