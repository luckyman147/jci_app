import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      labelText: "Begin Date",
      sheetTitle: "Date and Hour of begin",
      hintTextDate: "Begin Date",
      hintTextTime: "Begin Time",
      date: state.beginTimeInput.value ?? DateTime.now(),   mediaQuery: mediaQuery, timeType: TimeType.begin,);
  },
);
  }
}



class EndDateWidget extends StatefulWidget {


  const EndDateWidget({Key? key}) : super(key: key);

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
              builder: (context, state) {
                return DateFieldWidget(
                  labelText: "End Date",
                  sheetTitle: "Date and Hour of End",
                  hintTextDate: "End Date",
                  hintTextTime: "End Time",
                  date: state.endTimeInput.value ?? DateTime.now(),
                
                
               
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
      labelText: "Registration Deadline",
      sheetTitle: "Registration Date ",
      hintTextDate: "End Date",
      hintTextTime: "End Time",
      date: state.registrationTimeInput.value ?? DateTime.now(),  mediaQuery: mediaQuery, timeType: TimeType.registration,);
  },
);
  }
}
