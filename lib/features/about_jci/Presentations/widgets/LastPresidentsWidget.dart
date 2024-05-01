import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/app_strings.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/ShimmerEffects.dart';

import '../../../Home/presentation/widgets/AddActivityWidgets.dart';
import '../../../Home/presentation/widgets/Functions.dart';
import '../../Domain/entities/President.dart';
import 'dialogs.dart';

class LastPresidentsWidget extends StatelessWidget {

  final List<President> presidents;
  final bool hasReachedMax;
  final ScrollController controller;
  final bool mounted;
  const LastPresidentsWidget({Key? key, required this.presidents, required this.hasReachedMax, required this.controller, required this.mounted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: GridView.builder(
        itemCount: hasReachedMax?presidents.length:presidents.length+1,
        controller:controller ,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(

childAspectRatio: .8,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0, maxCrossAxisExtent:380.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return
            index>=presidents.length?ShimmerEffects.PresidensShimmer(false):
            body(index, context,mounted,presidents[index],TextEditingController());
        },
      ),
    );
  }

  Widget body(int index, BuildContext context,bool mounted,President? president,TextEditingController name,) {
    PersistentBottomSheetController? _bottomSheetController;
    var boxDecoration = BoxDecoration(
              border: Border.all(color: textColorBlack,width: 2),
    borderRadius: BorderRadius.circular(20),

            );
    return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
  builder: (context, state) {
    return InkWell(
      onLongPress: ()async{
      await Dialogs.SHowActionSheet(mounted, context,president, name,boxDecoration,state);
      },
      child: Container(

              decoration: boxDecoration,

              child: Padding(
                padding: paddingSemetricVerticalHorizontal(v: 15),
                child: Center(child: getPresidentWidget(presidents[index], context)),
              )),
    );
  },
);
  }





  Widget getPresidentWidget(President president, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
      SizedBox(

        child: Column(
          children: [
            pho(president, context),
            Text(president.name,
              textAlign: TextAlign.center,
              style:
            PoppinsSemiBold(18, textColorBlack, TextDecoration.none)
              ,),
            Text("President ${president.year}", style:PoppinsRegular(18, textColorBlack)
              ,),
          ],
        ),
      ),

        ],
      ),
    );
  }

  Container pho(President president, BuildContext context) {
    return president.CoverImage==null|| president.CoverImage.isEmpty?Container(
      height: 110,
      width: 110,
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
  child: ProfileComponents.phot(president.CoverImage, context,110),
);
  }

}
