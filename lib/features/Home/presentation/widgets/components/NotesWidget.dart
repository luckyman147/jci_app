

import 'package:jci_app/features/Home/domain/enums/ActivityCommentEnum.dart';
import '../../../Activity_Global.dart';
import '../../bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';

class ActivityCommentListWidget extends StatefulWidget {
  const ActivityCommentListWidget({Key? key, required this.activityId}) : super(key: key);
final String activityId;
  @override
  State<ActivityCommentListWidget> createState() => _ActivityCommentListWidgetState();
}

class _ActivityCommentListWidgetState extends State<ActivityCommentListWidget> {
  final ScrollController _scrollController = ScrollController();
/* 
  @override
  void initState() {

    _scrollController.addListener(_onScroll);
    // TODO: implement initState
    super.initState();
  }
 void _onScroll() {
    if (_isBottom) context.read<ActivityCommentBloc>().add(ActivityCommentfetched(activityId: widget.activityId, isUpdated: true));
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }*/
TextEditingController contentController = TextEditingController();
GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivityCommentBloc, ActivityCommentState>(
  listener: (context, ste) {
    if (ste.activityCommentEnum == ActivityCommentEnum.ADD_COMMENT) {


      contentController.clear();

      SnackBarMessage.showSuccessSnackBar(message: "Note Created Succesfully", context: context);

    }
    if (ste.activityCommentEnum == ActivityCommentEnum.DELETE_COMMENT) {

      SnackBarMessage.showSuccessSnackBar(message: "Note deleted Succesfully", context: context);

      context.read<ActivityCommentBloc>().add(GetActivitysComment( widget.activityId,));

    }
    if (ste.activityCommentEnum == ActivityCommentEnum.UPDATE_COMMENT) {

      contentController.clear();

      SnackBarMessage.showSuccessSnackBar(message: "Note Updated Succesfully", context: context);

    }   //  return addActivityComment(titleController,contentController,widget.activityId, formKey);
  //  return buildBlocConsumer();
    // TODO: implement listener}
  },
  child: Container()
);
  }



  Center BUildWhileNoActivityComment(BuildContext context) {
    return Center(child: InkWell(
    onTap: (){
      context.read<ActivityCubit>().changeNotePage(1);
    },
    child: SizedBox(
      height: MediaQuery.of(context).size.height*0.5,
      width: MediaQuery.of(context).size.width*0.8,
      child: DottedBorder(

        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        dashPattern: const [12, 16],
        color: textColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.add,size: 50,color: textColor,),
              const SizedBox(height: 10,),
              Text('Add The First Note',style: PoppinsRegular(14, textColorBlack),),



            ],
          ),
        ),
      ),
    ),
  ));
  }



}


