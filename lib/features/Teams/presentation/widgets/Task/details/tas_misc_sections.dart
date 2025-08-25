import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/domain/enums/Privacy.dart';
import 'package:jci_app/features/Teams/presentation/bloc/commentsdFile/comment_file_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/common/EditableTextField.dart';
import '../../../../../changelanguages/presentation/bloc/locale_cubit.dart';
import '../../../../domain/dto/TaskIdParams.dart';
import '../../../../domain/entities/Team/Team.dart';
import '../../../../domain/entities/TeamUser.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../bloc/GetTasks/get_task_bloc.dart';
import '../../../bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../bloc/Timeline/timeline_bloc.dart';
import '../../../bloc/members/members_cubit.dart';
import '../../../utils/FileStorage.dart';
import '../../../utils/TaskUtils.dart';
import '../../Team/Detail/DetailTeamComponents.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';

import '../../../../../../core/PrimitiveUser/User.dart';

import '../../file/FileUploadWidget.dart';
import '../Implementation/CommentsImpl.dart';
import '../components/TaskComponents.dart';

class TaskMiscSections extends StatelessWidget {
  final Tasks task;
  final Team team;
  final MediaQueryData mediaQuery;
  final TextEditingController controller;
  final FocusNode taskNameFocusNode;
  final bool hasPermissionAll;


  const TaskMiscSections({
    super.key,
    required this.task,
    required this.team,
    required this.hasPermissionAll,


    required this.mediaQuery,
    required this.controller,
    required this.taskNameFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: taskdex,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          buildAssignTo(context),
          buildAttachedfile(context),
          buildTimeline(context),
          buildDescription(context),

        ],
      ),
    );
  }



  Widget buildAssignTo(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: BlocBuilder<GetTaskBloc, GetTaskState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText("Members", mediaQuery),
              Row(
                children: [
                  state.task!.meta.assignToMembers.isNotEmpty
                      ? GestureDetector(
                    onTap: () {
                      context.read<MembersTeamCubit>().changeTypeMember(MembersChangeType.WillChange);

                      _openAssignBottomSheet
                    (context, state);},
                    child: DeatailsTeamComponent.membersTeamImage(
                      context,
                      mediaQuery,
                      state.task!.meta.assignToMembers.length,
                      state.task!.meta.assignToMembers,
                      30,
                      40,
                    ),
                  )
                      : const SizedBox(),
                  Visibility(
                      visible: hasPermissionAll ,
                      child:
                  Padding(
                    padding: paddingSemetricHorizontal(),
                    child: buildAddButton(() => _openAssignBottomSheet(context, state)),
                  ))
                ],
              )
            ],
          );
        },
      ),
    );
  }
  Widget buildAttachedfile(BuildContext context) {
    return BlocBuilder<CommentFileBloc, CommentFileState>(
      builder: (context, states) {
        return Padding(
          padding: paddingSemetricVerticalHorizontal(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText("Attached Files", mediaQuery),
                  // Ensure that the text and widgets below are laid out only once the layout phase is ready
                  const SizedBox(height: 10),

                  if (states is! CommentFileUploading && hasPermissionAll)
                    AddFileButton(() async {
                      final files = await FileStorage.pickFiles();

                      if (files.isNotEmpty) {
                        context.read<CommentFileBloc>().add(
                          UploadFilesEvent(
                            teamId: team.meta.id,
                            taskId: task.meta.id,
                            files: files,
                          ),
                        );
                      }
                    }),
                  // Make sure FileUploadWidget is handled with proper constraints
                  if (states is CommentFileUploading && hasPermissionAll)
                    SizedBox(
                      height: 100,
                      width: constraints.maxWidth,
                      child: FileUploadWidget(
                        files: context.watch<CommentFileBloc>().currentFiles,
                        teamId: team.meta.id,
                        taskId: task.meta.id,
                      ),
                    ),
                  if (task.content.attachedFiles.isNotEmpty)
                    AttachedFileWidget(
                      fileList: task.content.attachedFiles,
                      idTask: task.meta.id,
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
  Widget buildDescription(BuildContext context) {
    return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
      builder: (context, state) {
        return Padding(
          padding: paddingSemetricVerticalHorizontal(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildText('Description', mediaQuery),
              const SizedBox(height: 10),
state.textFieldsDescription==TextFieldsDescription.Active || (controller.text.isEmpty && task.content.description.isEmpty) && hasPermissionAll?
    EditableTextField(
      minLines: 3,
      hintText: "Description here",

        onChanged: (s){}, initialText: controller.text, onConfirm: (s){
        final field=UpdateTaskParams.fromDes(s, task);
        context.read<GetTaskBloc>().add(UpdateTaskDescriptionEvent(field, ));

    }, onCancel:() {
      context.read<TaskVisibleBloc>().add(
        const ChangeTextFieldsDescription(TextFieldsDescription.Inactive),
      );
    }):


                Padding(
                  padding: paddingSemetricVertical(),
                  child: InkWell(
                    splashColor: ColorsApp.textColor,
                    onTap: () {
                      context.read<TaskVisibleBloc>().add(
                        const ChangeTextFieldsDescription(TextFieldsDescription.Active),
                      );
                    },
                    child:Text(
                      controller.text,
                      style: PoppinsLight(
                        mediaQuery.devicePixelRatio * 4,
                        textColorBlack,
                      ),
                    ),),

                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildTimeline(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText("Timeline", mediaQuery),
          InkWell(
            onTap: () {
              if (hasPermissionAll){
              context.read<TimelineBloc>().add(initTimeline({
                'StartDate': task.meta.startDate,
                'Deadline': task.meta.deadline,
              }));
              _showTimelineBottomSheet(context);}
            },
            child: BlocBuilder<GetTaskBloc, GetTaskState>(
              buildWhen: (prev, curr) => prev.status != curr.status,
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BuildStart(mediaQuery, "Start Date", state.task!.meta.startDate),
                    BuildStart(mediaQuery, "Deadline", state.task!.meta.deadline),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget BuildStart(MediaQueryData mediaQuery, String date, DateTime time) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: SizedBox(
        width: mediaQuery.size.width / 3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: paddingSemetricHorizontal(h: 5),
              child: const Icon(
                Icons.access_time_rounded,
              ),
            ),
            BlocBuilder<localeCubit, LocaleState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: PoppinsRegular(15, ThirdColor),
                    ),
                    Text(
                      DateFormat("MMM,dd,yyyy",
                          state.locale == const Locale("en") ? "en" : 'fr')
                          .format(time),
                      style: PoppinsRegular(
                          mediaQuery.devicePixelRatio * 4, textColorBlack),
                    ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void _showTimelineBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: mediaQuery.size.height / 2.5,
          child: BlocBuilder<TimelineBloc, TimelineState>(
            builder: (context, timelineState) {
              return BottomShetTaskBody(
                context,
                mediaQuery,
                "Timeline",
                timelineState.timeline['StartDate'],
                timelineState.timeline['Deadline'],
                "Start Date",
                "Deadline",
                task,
                team.meta.id,
              );
            },
          ),
        );
      },
    );
  }

  void _openAssignBottomSheet(BuildContext context, GetTaskState state) {
    AssignBottomSheetBuilder(context, mediaQuery, (member) {
      _updateMemberAssignment(context, state, member, false);
    }, (member) {
      _updateMemberAssignment(context, state, member, true);
    }, team);
  }

  void _updateMemberAssignment(
      BuildContext context, GetTaskState state, TeamUser member, bool assign) {
    if (!context.mounted) return;
    final input = UpdateTaskParams(
      task: state.task!,
      member: member,
      memberStatus: assign,
      teamId: team.meta.id,
      taskId: task.meta.id,
    );
    context.read<GetTaskBloc>().add(UpdateMember(input, member));
    context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));
  }
}
