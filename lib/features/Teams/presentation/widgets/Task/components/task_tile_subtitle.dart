import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/strings/Images.string.dart';
import '../../../../../Home/Activity_Global.dart';
import '../../../../domain/entities/task/Task.dart';
import '../../../utils/TaskUtils.dart';
import 'IconActionButton.dart';

class TaskTileSubtitle extends StatelessWidget {
  final Tasks task;
final String teamId;
  const TaskTileSubtitle({super.key, required this.task, required this.teamId});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        ...task.meta.assignToMembers
            .take(3) // Limits the iteration to the first 3 members
            .map((member) {
          return Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12.r,
                    backgroundImage: member.user.Images.isNotEmpty
                        ? NetworkImage(member.user.Images[0])
                        : const AssetImage(images.PersonVip) as ImageProvider,
                  ),
                  SizedBox(width: 4.w),
                  AutoSizeText(
                    member.user.email.substring(0,member.user.email.indexOf('@')),
                    style: PoppinsRegular(12.sp, ColorsApp.textColorBlack),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),

        // Logic for displaying "+n others"
        if (task.meta.assignToMembers.length > 3)
          Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: Container(
              padding: EdgeInsets.all(6.w), // Adjust padding for the desired circle size
              decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(30), // Makes the container circular
                color: ColorsApp.textColor, // Background color of the circle
                 // Makes the container circular
              ),
              child: Text(
                '+${task.meta.assignToMembers.length - 3} others',
                style: PoppinsRegular(12.sp, Colors.white), // Change text color to white for contrast
              ),
            ),
          ),

   Align(
     alignment: Alignment.bottomRight,

       child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 10,
        children: [
          Row(
            spacing: 10,
            children: [
     if (task.content.attachedFiles.isNotEmpty)   BuildSnacke(Icons.attach_file, ColorsApp.PrimaryColor, "${task.content.attachedFiles.length} "),
     if (task.content.checkLists.isNotEmpty)   BuildSnacke(Icons.check_circle, ColorsApp.SecondaryColor, "${task.content.checkLists.length} "),
     if (task.communication.comments.isNotEmpty)   BuildSnacke(Icons.comment, ColorsApp.ThirdColor, "${task.communication.comments.length} "),

          ],),
       IconActionButton(
         color: ColorsApp.textColor,
          icon: Icons.more_vert,
          action: () {},
          destinations: TaskUtils.buildTaskOptionsMenu(
            onDelete: () {
              TaskUtils.DeleteTaskFunction(context, task, teamId);
            },
            onEdit: () {
              context.read<TaskVisibleBloc>().add(
                ToggleTaskVisibleById(task.meta.id),
              );
            },
            context: context,
          ),
        )
       ],),
   )
      ],
    );
  }

  Container BuildSnacke(IconData icon,Color color,String text ) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child:
        Row(
  children: [
    Icon(
      icon,
      color: color,
      size: 13.sp,
    ),

    AutoSizeText(
    text,
    style: PoppinsRegular(12.sp, color),
  ),],
  ),

      );
  }
}
