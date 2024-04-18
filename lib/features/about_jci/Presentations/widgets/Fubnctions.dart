import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/features/about_jci/Presentations/screens/AddUpdatePresidentsPage.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/PresWidgets.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../Home/presentation/widgets/Functions.dart';
import '../../../MemberSection/presentation/widgets/functionMember.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
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
  static showYearPickerDialog(BuildContext context,ScrollController con) async {
    final List<double> years = List.generate(
        (2100 - 1983 + 1), (index) => 1983.0 + index).reversed.toList();

    int yearIndex = years.indexOf(double.parse(context.read<ActionJciCubit>().state.cloneYear));

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.8,
            minHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: BlocBuilder<ActionJciCubit, ActionJciState>(
            builder: (BuildContext context, state) {
              return AlertDialog(
                title: Text('Select Year'),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Slider(value: yearIndex.toDouble(),
                  max: years.length.toDouble()-1,
                    min: 0,
                    label: years[yearIndex].toString(),
                    activeColor: PrimaryColor,
                    inactiveColor: Colors.grey,
                    onChanged: (value) {
                       yearIndex = years.indexOf(double.parse(context.read<ActionJciCubit>().state.cloneYear));

                      context.read<ActionJciCubit>().changeCloneYear(
                          value.toString());
                    },
                  )
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('CANCEL', style: PoppinsRegular(16, textColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('SAVE', style: PoppinsRegular(16, PrimaryColor)),
                    onPressed: () {
                      context.read<ActionJciCubit>().changeYear(state.cloneYear);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );


  }

  static bool isFormVisible(PresidentsAction action) =>
      action == PresidentsAction.Add || action == PresidentsAction.Update;
}