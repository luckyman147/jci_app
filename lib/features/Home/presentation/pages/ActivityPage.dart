import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';

import '../bloc/PageIndex/page_index_bloc.dart';



class ActivityPage extends StatefulWidget {
  final activity Activity;
  const ActivityPage({Key? key, required this.Activity}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  void initState() {
    if (widget.Activity == activity.Meetings) {
      context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: activity.Meetings));
    }
    else if (widget.Activity == activity.Events) {
      context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: activity.Events));
    }
    else if (widget.Activity == activity.Trainings) {
      context.read<AcivityFBloc>().add(GetAllActivitiesEvent(act: activity.Trainings));
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActivityCubit, ActivityState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(
                      onPressed: (){
                        context.read<PageIndexBloc>().add (SetIndexEvent(index:0));
          
          
                      }
          
                    ),
                    MyDropdownButton(),
                    Row(
                      children: [
                        AddButton(color: PrimaryColor, IconColor: textColorBlack, icon: Icons.add_rounded, onPressed: () {
                          context.go('/create');
                        }),
                        const SearchButton(
                          color: PrimaryColor, IconColor: textColorBlack,),
                      ],
                    ),
                  ],
                ),
          
                Expanded(
          
          
                    child: buildAllBody(context,state.selectedActivity))
              ]),
        );
      },
    );
  }
}
