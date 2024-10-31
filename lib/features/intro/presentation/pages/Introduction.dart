import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:jci_app/core/config/locale/app__localizations.dart';



import '../widgets/button_intro.dart';
import '../widgets/caroussel.dart';

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
                context.go( '/login');


              }),
            ],
          )

        ],
      ),
    );
  }
}
