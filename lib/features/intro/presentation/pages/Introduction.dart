import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:jci_app/core/config/locale/app__localizations.dart';



import '../../../../core/config/services/store.dart';
import '../widgets/button_intro.dart';
import '../widgets/caroussel.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Flex(


          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.vertical,
          children: [
//ElevatedButton(onPressed: (){context.go('/screen');}, child: Text('Change Language')),
            const Flexible(child: CarouselWidget()),
            Column(
              children: [
                button_intro_widget(text:"Explore".tr(context), onPressed: ()async  {
                  context.go( '/home');

                }),

                button_intro_widget_filled(text:"Get Started".tr(context), onPressed: ()async {
                  context.go( '/login');


                }),
              ],
            )

          ],
        ),
      ),
    );
  }
}
