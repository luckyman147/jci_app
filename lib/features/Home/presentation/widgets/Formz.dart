import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import 'AddActivityWidgets.dart';
 enum TimeType { begin, end, registration }
class BeginTimeWidget extends StatefulWidget {

  const BeginTimeWidget({Key? key}) : super(key: key);

  @override
  State<BeginTimeWidget> createState() => _BeginTimeWidgetState();
}

class _BeginTimeWidgetState extends State<BeginTimeWidget> {

  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);
    return BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return DateFieldWidget(
      labelText: "Begin Date".tr(context),
      sheetTitle: "Date and Hour of begin".tr(context),
      hintTextDate: "Begin Date".tr(context),
      hintTextTime: "Begin Time".tr(context),
      date: state.beginTimeInput.value ?? DateTime.now(),   mediaQuery: mediaQuery, timeType: TimeType.begin,);
  },
);
  }
}



class EndDateWidget extends StatefulWidget {
final String LabelText;
final String SheetTitle;
final String HintTextDate;
final String HintTextTime;


  const EndDateWidget({Key? key, required this.LabelText, required this.SheetTitle, required this.HintTextDate, required this.HintTextTime}) : super(key: key);

  @override
  State<EndDateWidget> createState() => _EndDateWidgetState();
}

class _EndDateWidgetState extends State<EndDateWidget> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);

    return BlocBuilder<VisibleBloc, VisibleState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: BlocBuilder<FormzBloc, FormzState>(
              builder: (context, ste) {
                return DateFieldWidget(
                  labelText: widget.LabelText,
                  sheetTitle: widget.SheetTitle,
                  hintTextDate: widget.HintTextDate,
                  hintTextTime: widget.HintTextTime,
                  date:  state.isVisible ?ste.endTimeInput.value ?? DateTime.now().add(Duration(days: 1)):
                  ste.beginTimeInput.value==null ?DateTime.now().add(Duration(days: 1)):ste.beginTimeInput.value!.add(Duration(days: 1)),
                
                
               
                  mediaQuery: mediaQuery, timeType: TimeType.end  
                );
              },
            ),
          ),
        );
      },
    );
  }
}
class RegistrationTime extends StatefulWidget {
  final DateTime Registration;
  const RegistrationTime({Key? key, required this.Registration}) : super(key: key);

  @override
  State<RegistrationTime> createState() => _RegistrationTimeState();
}

class _RegistrationTimeState extends State<RegistrationTime> {

  @override
  Widget build(BuildContext context) {
  final mediaQuery=MediaQuery.of(context);
    return BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return DateFieldWidget(
      labelText: "Registration Deadline".tr(context),
      sheetTitle: "Registration Date".tr(context),
      hintTextDate: "End Date".tr(context),
      hintTextTime: "End Time".tr(context),
      date: state.registrationTimeInput.value ?? DateTime.now(),  mediaQuery: mediaQuery, timeType: TimeType.registration,);
  },
);
  }
}
