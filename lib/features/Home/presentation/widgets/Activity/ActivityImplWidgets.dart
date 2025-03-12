
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';


import '../../../domain/entities/Activity.dart';
import '../../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../../bloc/Activity/activity_cubit.dart';

import '../Functions/Functions.dart';


Future<void> onRefresh(BuildContext context, activity act,
    List<Activity> actu) async {
  context.read<ParticpantsBloc>().add(
      initstateList(act: ActivityAction.mapObjects(actu)));

  context.read<AcivityFBloc>().add(GetActivitiesOfMonthEvent(act: act));
}

Future<void> onAllRefresh(BuildContext context, activity act,
    List<Activity> actu) async {
  context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: act));
  context.read<ParticpantsBloc>().add(
      initstateList(act: ActivityAction.mapObjects(actu)));
}




