import 'package:auto_size_text/auto_size_text.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/commentsdFile/comment_file_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/common/EditableTextField.dart';

import '../../../../../Home/Activity_Global.dart';
import '../../../utils/CommentsUtils.dart';
import '../../common/CommentTextField.dart';
import '../comments/CommentWidget.dart';

class Commentsimpl extends StatelessWidget {
  const Commentsimpl({super.key, required this.hasPermission ,required this.teamId, });
  final String teamId;
  final bool hasPermission ;

  @override
  Widget build(BuildContext context) {
    return

      BlocListener<CommentFileBloc, CommentFileState>(listener: (context,state){
        switch(state.status){
          case CommentStatus.InitCommentAdded:
            context.read<GetTaskBloc>().add(AddInitCommentEvent(state.comment));

          case CommentStatus.Added  :
            context.read<GetTaskBloc>().add(AddCommentIdEvent(state.commentId!,state.comment!.TaskId));
          default:


        }
      },child:
      BlocConsumer<GetTaskBloc, GetTaskState>(builder: (context,state){
      var id2 = state.task!.meta.id;
      if (state.task !=null && state.task!.communication.comments.isNotEmpty){
        return CommentsWidget(commentWidgets: state.task!.communication.comments, teamId: teamId,taskId: id2, haspermission: hasPermission,);
      }
  else {
        return
      Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,
        children: [
        AutoSizeText("No comments Found in this task",style: PoppinsRegular(16, ColorsApp.ThirdColor),),
         Visibility(
             visible: hasPermission,

             child:  Expanded(child: CommentInputField(teamId: teamId,taskId: id2, onSend: (String ) {
            CommentsUtils.AddCommentFunction(context, teamId: teamId, taskId: id2, content: String);

          },)))
        ],
      );
      }



    }, listener: (ctx,state){

    }));
  }
}
