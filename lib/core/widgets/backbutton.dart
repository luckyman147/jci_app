import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../strings/app_strings.dart';

Widget Backbutton(MediaQueryData mediaquery, BuildContext context,String text){
  return  Align(
      alignment: Alignment.topLeft,
      child:Padding(
        padding: EdgeInsets.only(top:mediaquery.size.height/23),
        child: InkWell(
            onTap: (){
              context.go(text);
            },

            child: SvgPicture.string(pic,width: 49,)),
      ));
}