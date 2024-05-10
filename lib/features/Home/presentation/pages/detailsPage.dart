import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';

import '../../domain/usercases/ActivityUseCases.dart';
import '../bloc/Activity/activity_cubit.dart';

class ActivityDetailsPage extends StatefulWidget {
  final String Activity;
  final String id;
  final int index;
  const ActivityDetailsPage({Key? key, required this.Activity, required this.id, required this.index}) : super(key: key);

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPageState();
}

class _ActivityDetailsPageState extends State<ActivityDetailsPage> {
  late activity act;
  @override
  void initState() {
    if (widget.Activity == 'Meetings') {
      final result=        activityParams(type: activity.Meetings, act: null,id: widget.id, name: '');
      context.read<AcivityFBloc>().add(GetActivitiesByid(params: result));
    }
    else if (widget.Activity == 'Trainings') {
      final result=        activityParams(type: activity.Trainings, act: null,id: widget.id, name: '');
      context.read<AcivityFBloc>().add(GetActivitiesByid(params: result));

    }
    else if (widget.Activity == 'Events') {
      final result=        activityParams(type: activity.Events, act: null,id: widget.id, name: '');
      context.read<AcivityFBloc>().add(GetActivitiesByid(params: result));
    }

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return  BlocBuilder<AcivityFBloc, AcivityFState>(
  builder: (context, state) {
    return Scaffold(

      body: SingleChildScrollView(
        child: BlocBuilder<ActivityCubit, ActivityState>(
          builder: (context, state) {
            return buildActivityDetailsBody(context, state.selectedActivity, widget.id,widget.index);
          },
        ),
      ),
    );
  },
);
  }
}
