import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/strings/Images.string.dart';
import '../../../../../Home/Activity_Global.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../utils/TaskUtils.dart';
import '../../Team/Detail/DetailTeamComponents.dart';
import 'IconActionButton.dart';
import 'TaskNameEditor.dart';

class TaskTileSubtitle extends StatelessWidget {
  final Tasks task;
final String teamId;
final bool hasPermission;
  const TaskTileSubtitle({super.key,required this.hasPermission, required this.task, required this.teamId});

  @override
  Widget build(BuildContext context) {
    var bool = (task.content.attachedFiles.isNotEmpty || task.content.checkLists.isNotEmpty||
        task.communication.comments.isNotEmpty);

    return Flex(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      direction: Axis.vertical,
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child:
        Row(
            mainAxisAlignment: MainAxisAlignment.start,

            spacing: 5,
            children: [
       Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DeatailsTeamComponent.membersTeamImage(context, MediaQuery.of(context), task.meta.assignToMembers.length, task.meta.assignToMembers, 20  , 40)
            ),
          ),

              Visibility(
                  visible: hasPermission,
                  child:
              buildActionsTaskButtons()),
          Visibility(
              visible: hasPermission,
              child:
          IconActionButton(
            color: ColorsApp.textColor,
            icon: Icons.more_vert,
            action: () {},
            destinations: TaskUtils.buildTaskOptionsMenu(
              onDelete: () {
                if (!hasPermission) return;
                TaskUtils.DeleteTaskFunction(context, task, teamId);
              },
              onEdit: () {
                if (!hasPermission) return;
                context.read<TaskVisibleBloc>().add(
                  ToggleTaskVisibleById(task.meta.id),
                );
              },
              context: context,
            ),
          ))
])),
        // Logic for displaying "+n others"


   Align(
     alignment: Alignment.centerLeft,

       child:

          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: [
     if (task.content.attachedFiles.isNotEmpty)   BuildSnacke(Icons.attach_file, ColorsApp.PrimaryColor, "${task.content.attachedFiles.length} ","Files"),
     if (task.content.checkLists.isNotEmpty)   BuildSnacke(Icons.check_circle, ColorsApp.SecondaryColor, "${task.content.checkLists.length} ","Tasks"),
     if (task.communication.comments.isNotEmpty)   BuildSnacke(Icons.comment, ColorsApp.ThirdColor, "${task.communication.comments.length} ","comment"),



       ],),
   )
      ],
    );
  }

  Container BuildSnacke(IconData icon,Color color,String text,String type ) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child:
        Row(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(
      icon,
      color: color,
      size: 13.sp,
    ),

    AutoSizeText(
    text,
    style: PoppinsRegular(12.sp, color),
  ),
    AutoSizeText(type,
    style:  PoppinsRegular(12.sp, color),
    )

  ],
  ),

      );
  }
}
