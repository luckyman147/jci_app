import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';

Future <void> ChooseTimeOFDay(BuildContext context,TimeOfDay Time,bool mounted )async {
  TimeOfDay time = Time;
  final temp = await showTimePicker(
    context: context,
    initialTime: time,
  );
  if (temp != null) {
    if(!mounted) return;
    debugPrint("$temp");
    context.read<FormzBloc>().add(jokerTimeChanged(joketimer: temp));
  }
}
Future<void> DatePicker(BuildContext context ,bool mounted)async {

  final temp = await showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 365)),
  );

  if (temp != null) {
    if (!mounted) return;
    context.read<FormzBloc>().add(jokerChanged(joke: temp));
  }
}