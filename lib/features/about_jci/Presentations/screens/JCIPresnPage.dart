import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/PresWidgets.dart';

class PresentationsPage extends StatefulWidget {
  const PresentationsPage({Key? key}) : super(key: key);

  @override
  State<PresentationsPage> createState() => _PresentationsPageState();
}

class _PresentationsPageState extends State<PresentationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          children: [

            Text('Presentation',style:PoppinsSemiBold(20, textColorBlack, TextDecoration.none))
          ],
        ),
        backgroundColor: textColorWhite,
      ),
      body:SafeArea(child: SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Stack(
                children: [
                  // Left Column of Text
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        PresWidgets.HeaderText("jci_presentations".tr(context),context),
                        PresWidgets.description("description_jci_Inter".tr(context), henry,context),
                        PresWidgets.HeaderText("PRESENTATION OF JCI TUNISIA".tr(context),context),
                        PresWidgets.description("description_jci_Tunisia".tr(context), henry,context),
                        PresWidgets.HeaderText("PRESENTATION OF JCI HAMMAM SOUSSE".tr(context),context),
                        PresWidgets.description("description_jci_HammamSousse".tr(context), henry,context),
                      ],
                    ),
                  ),
                  // Right Slider
                  Positioned(
                    top: 0,
                    right: 0,
                    child: PresWidgets.buildSlider(context, [PresWidgets.FirstDescriptionHeight(context), PresWidgets.SecondDescriptionHeight(context), PresWidgets.ThirdDescriptionHeight(context)], [henry, jciTun, jciHammem]),
                  ),
                ],
              ),
            ),
          ),
        ],

      ),),)
    );
  }



}
