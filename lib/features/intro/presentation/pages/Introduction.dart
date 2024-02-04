import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';


import '../widgets/button_intro.dart';
import '../widgets/caroussel.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration:const  BoxDecoration(color: backgroundColored),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Expanded(

                    child: CarouselWidget()

                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      button_intro_widget(text:"Explore", onPressed: () {
                        context.go( '/login');
                      }),

                      button_intro_widget(text:"Login", onPressed: () {
                        context.go( '/login');
                      }),
                    ],
                  ),
                )

              ],
            ),
          )
      ),
    );
  }
}
