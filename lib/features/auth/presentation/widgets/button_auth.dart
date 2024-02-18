import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:jci_app/core/app_theme.dart';

import '../../domain/entities/Member.dart';
import '../bloc/SignUp/sign_up_bloc.dart';

class authButton extends StatelessWidget {
  const authButton({Key? key, required this.onPressed, required this.text, required this.string})
      : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final String string ;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
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
        child: InkWell(
   borderRadius: BorderRadius.circular(14),

          highlightColor: PrimaryColor.withOpacity(0.3),
          onTap: onPressed,
          child: Flex(
          direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width/20),
            child:   SvgPicture.string(string),
          ),
              Text(text,style: PoppinsRegular(mediaQuery.size.width/30, textColorBlack),),
            ],
          ),
        ),
      ),
    );
  }
}


