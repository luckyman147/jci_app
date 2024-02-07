import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jci_app/core/app_theme.dart';

class authButton extends StatelessWidget {
  const authButton({Key? key, required this.onPressed, required this.text, required this.string})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final String string ;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding:  EdgeInsets.symmetric(vertical:mediaQuery.size.height/70 ),
        child: Container(
          height: mediaQuery.size.height / 15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: textColorBlack
                  ,
              width: 2
          )),
          child: Flex(
direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
Padding(
  padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width/20),
  child:   SvgPicture.string(string),
),
              Text(text,style: PoppinsRegular(mediaQuery.size.width/20, textColorBlack),),
            ],
          ),
        ),
      ),
    );
  }
}