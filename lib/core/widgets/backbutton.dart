import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../strings/app_strings.dart';


class Backbutton extends StatelessWidget {
  const Backbutton({
    super.key, required this.text,  this.onTap,
  });
final PageRouteInfo text ;
final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    return Align(
        alignment: Alignment.topLeft,
        child:Padding(
          padding: EdgeInsets.only(top:mediaquery.size.height/23),
          child: InkWell(
              onTap: (){
                context.pushRoute(text);

               if (onTap != null) {
                 onTap!();
               }
              },

              child: SvgPicture.string(pic,width: 49,)),
        ));
  }
}