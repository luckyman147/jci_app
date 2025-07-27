import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';


import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/route/app_router.dart';



import '../widgets/button_intro.dart';
import '../widgets/caroussel.dart';
@RoutePage()
class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(


        mainAxisAlignment: MainAxisAlignment.center,

        children: [
      //ElevatedButton(onPressed: (){context.go('/screen');}, child: Text('Change Language')),
          const Expanded(
              flex: 2,
              child: CarouselWidget()),
          Column(
            children: [


              button_intro_widget_filled(text:"Get Started".tr(context), onPressed: ()async {
                context.navigateTo( LoginRoute());


              }),
            ],
          )

        ],
      ),
    );
  }
}
