
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';

import 'package:jci_app/features/Teams/presentation/widgets/TaskImpl.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamComponent.dart';


import '../../../../core/app_theme.dart';


import '../../domain/entities/Team.dart';

import 'DetailTeamComponents.dart';

class TeamDetailWidget extends StatefulWidget {
  final Team team;

  final TextEditingController taskController;

  TeamDetailWidget({Key? key, required this.team, required this.taskController})
      : super(key: key);

  @override
  State<TeamDetailWidget> createState() => _TeamDetailWidgetState();
}

class _TeamDetailWidgetState extends State<TeamDetailWidget> {
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: SingleChildScrollView(
        child:
        BlocBuilder<GetTaskBloc, GetTaskState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                      width: mediaQuery.size.width / .6,

                      child:DeatailsTeamComponent. Header(context, mediaQuery,widget.team,mounted)),
                ),
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.size.width / 20, vertical: 10),
                    child: DeatailsTeamComponent.description(mediaQuery, context,widget.team,mounted),
                  ),
                ),

                state.tasks.isEmpty ? SizedBox() :
                Column(
                  children: [
                    DeatailsTeamComponent.buildProgressText(state),


                    Align(
                        alignment: Alignment.center,
                        child: DeatailsTeamComponent.ProgessBar(mediaQuery, context,)),
                  ],
                ),


                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width / 20,),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [

                      Text('Tasks', style: PoppinsSemiBold(
                          mediaQuery.devicePixelRatio * 6, textColorBlack,
                          TextDecoration.none),),
                      state.tasks.isEmpty ? SizedBox() :
                      DeatailsTeamComponent. buillLinkedtext(mediaQuery, widget.team),

                    ],
                  ),
                ),
                Column(


                  children: [
                    TaskAddField(widget.taskController, widget.team.id),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: paddingSemetricVerticalHorizontal(v: 10, h: 0),
                        child: myTaskButtons(),
                      ),
                    )
                    , SizedBox(

                      height: mediaQuery.size.height / 1.5,
                      child: GetTasksWidget(
                          widget.team, mediaQuery, widget.taskController),
                    ),

                  ],
                ),
              ],

            );
          },
        )

        ,),
    );
  }
}

