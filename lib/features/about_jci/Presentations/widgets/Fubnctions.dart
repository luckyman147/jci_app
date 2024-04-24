import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/about_jci/Domain/entities/BoardRole.dart';
import 'package:jci_app/features/about_jci/Domain/useCases/BoardUseCases.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/BoardBloc/boord_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/BoardBloc/boord_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/YearsBloc/years_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/YearsBloc/years_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/screens/AddUpdatePresidentsPage.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/BoardComponents.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/BoardImpl.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/PresWidgets.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../Home/presentation/widgets/Functions.dart';
import '../../../MemberSection/presentation/widgets/functionMember.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../Domain/entities/Post.dart';
import '../../Domain/entities/President.dart';
import '../bloc/presidents_bloc.dart';
import 'LastPresidentsWidget.dart';

class JCIFunctions {
  static double getHeight(String text, double fontSize, double width) {
    final TextPainter textPainter = TextPainter(
      maxLines: null,
      text: TextSpan(
        text: text,
        style: PoppinsRegular(fontSize, textColorBlack,),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: width);

    return textPainter.height;
  }
  static void ListenerIsAdded(PresidentsState state, BuildContext context) {
    if (state.state== presidentsStates.Changed) {
      // context.read<PresidentsBloc>().add(GetAllPresidentsEvent());

      SnackBarMessage.showSuccessSnackBar(message: state.message, context: context);
      Navigator.pop(context);
    } else if (state.state == presidentsStates.Error) {
      SnackBarMessage.showErrorSnackBar(message: state.message, context: context);
    }
  }

  static bool stringExistsOrselectedInList(List<String> list, String value) {
    return list.contains(value);
  }
  static void showYearSelectionDialog(BuildContext context) {
    List<String> yearsList = List.generate(30, (index) => (2022 + index).toString());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BoardComponents. AlertAddBoard(yearsList);},
    );
  }
  static void showDeleteBoard(BuildContext context ,String year) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BoardComponents. alertDialogDelete(year, context);



  });}
static void showPosAction(BuildContext context,Post post , TextEditingController _SearchController) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return BoardComponents. showPosWidget(context,post,_SearchController);
      },
    );
  }
  static void showAddNewRole(BuildContext context,Post post) {
    showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SizedBox();
    },
  );
  }


  static void showAddPosition(BuildContext context,PageController controller) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return BoardComponents. AddPositionWidget(controller);
      },
    );

  }
  static  void ChangeRoleFunction(YearsState state, BoardRole role, BuildContext context) {
    if (state.newrole['role'] != role) {
      context.read<YearsBloc>().add(ChangeRoleEvent(role: role));
    }
    else{
      context.read<YearsBloc>().add(ChangeRoleEvent(role: null));
    }
  }
  static   bool isSelected(YearsState state, BoardRole role) => state.newrole['role']!=null&& state.newrole['role'] .id == role.id;












  static Future<void> SHowActionSheet(bool mounted, BuildContext context,
      President? president, TextEditingController name,
      BoxDecoration boxDecoration) async {
    if (await FunctionMember.isSuper()) {
      if (!mounted) return;
      await showModalBottomSheet(


          showDragHandle: true,
          context: context, builder: (context) {
        return
          PresWidgets.sheetbody(
              boxDecoration, president, name, mounted, context);
      });
    }
  }

  static Future<void> uPdateAction(President president,
      bool mounted,
      BuildContext context) async {
    {
      log('ffffff');
    }
  }
  static List<String> insertSorted(List<String> sortedList, String number) {
    int? numberValue = int.tryParse(number) ?? double.tryParse(number)?.toInt();
    if (numberValue == null) {
      throw ArgumentError('The number should be a valid integer or double string.');
    }

    int index = sortedList.indexWhere((element) {
      int? elementValue = int.tryParse(element) ?? double.tryParse(element)?.toInt();
      return elementValue != null && elementValue > numberValue;
    });

    if (index < 0) {
      index = sortedList.length;
    }

    sortedList.insert(index, number);
    return sortedList;
  }

static   void update( TaskVisibleState state, BuildContext context, TextEditingController name, President? presidents, PresidentsAction action,GlobalKey<FormState> form,TextEditingController year) {
  if (state.image.isEmpty || !form.currentState!.validate() ){
    SnackBarMessage.showErrorSnackBar(message: "Something  Empty", context: context);

  }
  else {
  if (action == PresidentsAction.Add) {


    final President president = President(name: name.text, year: year.text, CoverImage: state.image, id: '');
    context.read<PresidentsBloc>().add(CreatePresident(president));
  } else if (action == PresidentsAction.Update) {
    final President president = President(name: name.text, year: year.text, CoverImage: state.image, id: presidents!.id);

    context.read<PresidentsBloc>().add(UpdatePresident(president));
  }}
}




static ListenerBoard(BuildContext context, YearsState state, BoordState ste){
  if (ste.state == BoardStatus.Changed) {

    context.read<YearsBloc>().add(ChangeBoardYears(year: state.years[0]));

    context.read<YearsBloc>().add(GerBoardYearsEvent());


    SnackBarMessage.showSuccessSnackBar(
        message: ste.message, context: context);
    context.read<YearsBloc>().add(ChangeCloneYear(year:""));

  }
  else if (ste.state == BoardStatus.Removed) {

    context.read<YearsBloc>().add(GerBoardYearsEvent());
    context.read<YearsBloc>().add(ChangeBoardYears(year: state.years[0]));




    SnackBarMessage.showSuccessSnackBar(
        message: ste.message, context: context);
  }

  else if (ste.state == BoardStatus.Error) {

    SnackBarMessage.showErrorSnackBar(
        message: ste.message, context: context);
  }

}
static bool isExist(Member member,Map<String, dynamic> map){
    if (map['member'] == null || map['member'] is! Member || member.id == null) {
      return false;
    }
    return member.id == (map['member'] as Member).id;
}static bool IsNotEmpty(Map<String, dynamic> map){
    if (map['member'] == null || map['member'] is! Member ) {
      return false;
    }
    return true;
}
  static void AddMemberFun(YearsState ste, ActionJciState state, BuildContext context,String postId) {
    final postField = PostField(year: ste.year,
        role: '',
        assignTo: (state.member['member'] as Member)
            .id,
        id: postId);
    context.read<BoordBloc>().add(AddMemberEvent(postField: postField));
    Navigator.pop(context);
  }

static bool isFormVisible(PresidentsAction action) =>
      action == PresidentsAction.Add || action == PresidentsAction.Update;
}