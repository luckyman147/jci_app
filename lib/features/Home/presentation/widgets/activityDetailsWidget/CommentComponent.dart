import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/domain/Dtos/NoteInput.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';

import '../Activity/ActivityImplWidgets.dart';
import '../Functions/ActivityDetailsFunctions.dart';
import '../Implementations/CommentsImpl.dart';
import '../components/pv&notes/SendingTextField.dart';
import '../components/pv&notes/TextFieldComments.dart';
import 'CommentWidget.dart';

class CommentsScreen extends StatelessWidget {
  final String activityId;
  final String id;
  final TextEditingController controller = TextEditingController();

  CommentsScreen({super.key, required this.activityId, required this.id});

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return BlocBuilder<ActivityCommentBloc, ActivityCommentState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: 450.h,
                child: ActivityCommentImpl((comments) {
              return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return CommentWidget(
                      comment: comments[index],
                      onReplyAdded: (content) async {
                        await ActivityDetailsFunctions.CreateReplyToComment(
                            content,
                            context,
                            activityId,
                            comments[index].Commentid);
                      },
                      id: id,
                    );
                  });
            }, activityId)),
            CommentTextField(state: state,controller: controller,activityId: activityId,)
          ],
        );
      },
    );
  }
}
