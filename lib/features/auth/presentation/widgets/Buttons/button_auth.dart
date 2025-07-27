


import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';

import '../../../AuthWidgetGlobal.dart';
class authButton extends StatelessWidget {
  const authButton({Key? key, required this.onPressed, required this.text, required this.icon, required this.isLoading, required this.isoogl})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final IconData icon ;
  final bool isLoading;
  final bool isoogl;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height : isLoading?  mediaQuery.size.height / 10:  mediaQuery.size.height / 15,
      decoration: BoxDecoration(
        color:ColorsApp.textColorWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColorBlack
              ,
          width: 2
      )),
      child: InkWell(
       borderRadius: BorderRadius.circular(14),

        highlightColor: PrimaryColor.withOpacity(0.3),
        onTap: onPressed,
        child: Flex(
        direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
        Padding(
          padding: paddingSemetricHorizontal(h: mediaQuery.size.width/20)
            ,            child:
      isLoading ?
        LoadingWidget()

      :
      FaIcon(
          icon,

          size: mediaQuery.size.width/15,
        ),
        ),

            Text(text,style: PoppinsRegular(18.sp, ColorsApp.textColorBlack),),
          ],
        ),
      ),
    ).animate(
     effects: [
       FadeEffect(duration: 500.milliseconds),

     ]

    );
  }
}


