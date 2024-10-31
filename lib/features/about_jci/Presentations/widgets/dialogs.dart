import 'package:flutter/material.dart';

import '../../../MemberSection/presentation/widgets/functionMember.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../Domain/entities/Post.dart';
import '../../Domain/entities/President.dart';
import '../bloc/ActionJci/action_jci_cubit.dart';
import '../screens/AddUpdatePresidentsPage.dart';
import 'BoardComponents.dart';
import 'PresComponents.dart';
import 'PresWidgets.dart';

class Dialogs{

  static Future<void> SHowActionSheet(bool mounted, BuildContext context,
      President? president, TextEditingController name,
      BoxDecoration boxDecoration,TaskVisibleState state) async {
    if (await FunctionMember.isSuper()) {
      if (!mounted) return;
      await showModalBottomSheet(


          showDragHandle: true,
          context: context, builder: (context) {
        return
          PresWidgets.sheetbody(
              boxDecoration, president, name, mounted,state, context);
      });
    }
  }
  static void showAddPosition(BuildContext context,PageController controller,TextEditingController nameController) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return BoardComponents. AddPositionWidget(controller,nameController);
      },
    );

  }
  static void showPosAction(BuildContext context,Post post , TextEditingController SearchController) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return BoardComponents. showPosWidget(context,post,SearchController);
      },
    );
  }

  static void showYearSelectionDialog(BuildContext context) {
    List<String> yearsList = List.generate(30, (index) => (2022 + index).toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BoardComponents. AlertAddBoard(yearsList);},
    );
  }  static void showYearPresidentsSelectionDialog(BuildContext context) {
    List<String> yearsList = List.generate(DateTime.now().year+4-1983, (index) => (1983 + index).toString()).reversed.toList();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PresidentsComponents. AlertAddYearPresidents(yearsList);},
    );
  }
  static void showDelete(BuildContext context ,String year,TypeDelete typeDelete,String roleid) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BoardComponents. alertDialogDelete(year,roleid ,context,typeDelete,typeDelete==TypeDelete.Board? '${typeDelete.name} $year ':typeDelete.name);



        });}
  static ShoUpdateAddPresident(BuildContext context,President? president,PresidentsAction action) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,

      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height ,
            width: MediaQuery.of(context).size.width,

            child: AddUpdatePage(president: president,action: action,));
      },
    );
  }

}