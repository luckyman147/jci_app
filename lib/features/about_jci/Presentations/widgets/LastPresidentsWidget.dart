import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';

import '../../Domain/entities/President.dart';

class LastPresidentsWidget extends StatelessWidget {

  final List<President> presidents;
  const LastPresidentsWidget({Key? key, required this.presidents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: GridView.builder(
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(


          mainAxisSpacing: 40.0,
          crossAxisSpacing: 20.0, maxCrossAxisExtent:320.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(

              decoration: BoxDecoration(
                border: Border.all(color: textColorBlack,width: 2),
      borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [textColorWhite,textColorWhite],
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: getPresidentWidget(presidents[index], context)),
              ));
        },
      ),
    );
  }

  Widget getPresidentWidget(President president, BuildContext context) {
    return Column(
      children: [
    pho(president, context),
    Text(president.name,
      textAlign: TextAlign.center,
      style:
    PoppinsSemiBold(18, textColorBlack, TextDecoration.none)
      ,),
    Text("President ${president.year}", style:PoppinsRegular(18, textColorBlack)
      ,),
        ProfileComponents.buildFutureBuilder(
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
        IconButton.outlined(onPressed: (){}, icon: Icon(Icons.edit)),
        IconButton.outlined(onPressed: (){}, icon: Icon(Icons.delete))
              ]),


            true, "", (p0) => FunctionMember.isSuper())
      ],
    );
  }

  Container pho(President president, BuildContext context) {
    return president.CoverImage==null|| president.CoverImage.isEmpty?Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: textColorWhite,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: textColor, width: 4.0),

      ),
      child:CircleAvatar(
backgroundColor: textColorWhite,
        backgroundImage: AssetImage(vip),
      )
    ):
Container(
  decoration: BoxDecoration(
    color: textColorWhite,
    borderRadius: BorderRadius.circular(100),
    border: Border.all(color: textColor, width: 4.0),

  ),
  child: ProfileComponents.phot(president.CoverImage, context),
);
  }

}
