
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/presentation/widgets/Implementations/ActivtysImplementations.dart';


import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';

import 'package:jci_app/features/Teams/presentation/widgets/Task/Implementation/TaskImpl.dart';
import 'package:jci_app/features/Teams/presentation/widgets/Team/%20component/TeamComponent.dart';


import '../ component/ActivityInfoTile.dart';
import '../../../../../../core/app_theme.dart';


import '../../../../domain/entities/Team/Team.dart';

import '../../../../domain/entities/task/Task.dart';
import '../../../bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../common/EditableTextField.dart';
import '../../common/TaskProgressBarWithLegend.dart';
import '../../common/actionsbuttons.dart';
import 'DetailTeamComponents.dart';

class TeamDetailWidget extends StatefulWidget {
  final Team team;

  final TextEditingController taskController;

  const TeamDetailWidget({Key? key, required this.team, required this.taskController})
      : super(key: key);

  @override
  State<TeamDetailWidget> createState() => _TeamDetailWidgetState();
}

class _TeamDetailWidgetState extends State<TeamDetailWidget> {
  final TextEditingController _taskNameController = TextEditingController();
  @override
  void initState() {
    context.read<GetTaskBloc>().add(GetTasks(id:widget.team.meta.id,filter: TaskCompletionStatus.Todo));

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return
      Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor:ColorsApp.backgroundColored,


          actions: [

              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: widget.team.meta.status ? Colors.red : Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 20),
           DeatailsTeamComponent.  MembersAssignTo(mediaQuery, widget.team, mounted),

          ],
        title:                 DeatailsTeamComponent. Header(context, mediaQuery,widget.team,mounted),
    ),


    body:   Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: SingleChildScrollView(
        child:
        BlocBuilder<GetTaskBloc, GetTaskState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [


if (widget.team.meta.event != null)
  ActivityInfoTile(activity:  widget.team.meta.event!),










                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width / 20,),

                  child
                      :
                  BlocSelector<TaskVisibleBloc, TaskVisibleState, bool>(
                    selector: (state) => state.willSearch,
                    builder: (context, willSearch) {
                      if (willSearch) {
                        return EditableTextField(
                          hintText: "Search task",
                          focusedColor: ColorsApp.PrimaryColor,
                          onChanged: (s){},
                          onConfirm: (s){},
                          onCancel: (){
                            context.read<TaskVisibleBloc>().add(const ChangeWillSearchEvent(false));
                          },

                          initialText: "",




                        ); // Replace with your actual editable widget
                      } else {
                        return     Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [

                            Text("${"Task".tr(context)}s", style: PoppinsSemiBold(
                                mediaQuery.devicePixelRatio * 6, textColorBlack,
                                TextDecoration.none),),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: paddingSemetricVerticalHorizontal(v: 10, h: 0),
                                child: const MyTaskButtons(),
                              ),
                            )


                            //  state.tasks.isEmpty ? const SizedBox() :
                            // DeatailsTeamComponent. buillLinkedtext(mediaQuery, widget.team),

                          ],
                        );
                      }
                    },
                  ),










                ),
                Column(


                  children: [


                     SizedBox(
                  height: mediaQuery.size.height * 0.7,


                      child: GetTasksWidget(
                          widget.team, mediaQuery, widget.taskController),
                    ),
SizedBox(height: 10,),
                    TaskProgressBarWithLegend (

                      tasks: state.tasks,
                    ),


                  ],
                ),
              ],

            );
          },
        )

        ,),
    ));
  }
}

