import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/PresWidgets.dart';

import 'BoardPage.dart';

class PresentationsPage extends StatefulWidget {
  const PresentationsPage({Key? key}) : super(key: key);

  @override
  State<PresentationsPage> createState() => _PresentationsPageState();
}

class _PresentationsPageState extends State<PresentationsPage> {
   late ScrollController controller ;
   late ScrollController contae;
   double _offset = 0;
   List<String> images=[henry, jciTun, jciHammem];
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    controller = ScrollController();
    contae = ScrollController();
    contae.addListener(_scrollListener);
    controller.addListener(_scrollListener);

   // log(PresWidgets.SecondDescriptionHeight(context).toString());
   // log(PresWidgets.SecondDescriptionHeight(context).toString());
  }
   @override
   void dispose() {
     controller.removeListener(_scrollListener);
     controller.dispose();
     super.dispose();
   }

   void _scrollListener() {
     setState(() {
       _offset = controller.offset;


     });
   }
  @override
  Widget build(BuildContext context) {
    List<double> heights=[PresWidgets.FirstDescriptionHeight(context), PresWidgets.SecondDescriptionHeight(context), PresWidgets.ThirdDescriptionHeight(context)];

    return Scaffold(
      appBar: AppBar(
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text('Presentation'.tr(context),style:PoppinsSemiBold(20, textColorBlack, TextDecoration.none)),
            TextButton(child: Row(
              children: [
                Text('Board'.tr(context),style:PoppinsSemiBold(16,PrimaryColor, TextDecoration.underline)),
Icon(Icons.arrow_forward_ios_rounded,color: PrimaryColor,)
              ],
            ),onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BoardPage()));

            },)
          ],
        ),
        backgroundColor: textColorWhite,
      ),
        floatingActionButton:
       _offset > 0?

        FloatingActionButton(
          //oval
          elevation: 5,
          shape:
       const    CircleBorder(
              side: BorderSide(
                  color: Colors.white,
                  width: 2
              )
          ),
          onPressed: () {},
          child: GestureDetector(
            onTap: () {
              controller.animateTo(JCIFunctions.countNumbersGreaterThan(_offset,heights )[1].toDouble(), duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            },
            child: PresWidgets.avatarImage(


                images[JCIFunctions.countNumbersGreaterThan(_offset,heights )[0].toInt()]



                ),
          )
        ):null,

        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,


      body:SafeArea(child: SingleChildScrollView(

        controller: controller,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Padding(
            padding: const EdgeInsets.all(16.0),
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
                  child: PresWidgets.buildSlider(context, heights, images, contae),
                ),
              ],
            ),
          ),
        ],

      ),),)
    );
  }



}
