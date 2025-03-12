import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/Home/data/model/meetingModel/MeetingModel.dart';
import 'package:jci_app/features/Home/presentation/widgets/activityDetailsWidget/CommentComponent.dart';

import '../../../Activity_Global.dart';
import '../../../domain/entities/Meeting.dart';
import '../../bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import '../../bloc/PageIndex/page_index_bloc.dart';
import '../../bloc/Poll/poll_bloc.dart';
import '../Activity/ActivityDetailsComponents.dart';
import '../Activity/AddActivityWidgets.dart';
import '../Fields/AddPoll.dart';
import '../Implementations/PVImpl.dart';
import '../Implementations/PollImpl.dart';
import 'AgendaWidget.dart';
import 'CommentWidget.dart';
import 'Containerdivider.dart';

class SectionViewer extends StatefulWidget {
  final activity act;

  const SectionViewer({super.key, required this.act});
  @override
  _SectionViewerState createState() => _SectionViewerState();
}

class _SectionViewerState extends State<SectionViewer> {
  late PageController _pageController;


  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery=MediaQuery.of(context);
    return BlocBuilder<PageIndexBloc, PageIndexState>(
  builder: (context, state) {
    return Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderTab(0, 'About',mediaquery,Viewsection.About),


              _buildAboutSection(mediaquery,state),
            ],
          ),
          NoImageCard(ColorsApp.BackWidgetColor,10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderTab(0, 'Description',mediaquery,Viewsection.Description),
              Visibility(
                  visible: state.viewsection==Viewsection.Description,
                  child: ActivityDetailsComponent.Description(mediaquery, context.read<AcivityFBloc>().state.activityById!)),

            ],
          ),
          NoImageCard(ColorsApp.BackWidgetColor,10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.act==activity.Meetings?_buildHeaderTab(1, "Agenda",mediaquery,Viewsection.Agenda):Container(),
              widget.act==activity.Meetings?_buildAgendaSection(mediaquery,state):Container(),
              widget.act==activity.Meetings?NoImageCard(ColorsApp.BackWidgetColor,10):Container(),

            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.act==activity.Meetings?_buildHeaderTab(1, "PV",mediaquery,Viewsection.PV):Container(),
              widget.act==activity.Meetings?
                  Visibility(
                      visible: state.viewsection==Viewsection.PV,
                      child: SizedBox(
                    width: mediaquery.size.width,


                  child:PVImpl( activityId: context.read<AcivityFBloc>().state.activityById!.id),

                  )
                  
                  )
                  
                  
                  :Container(),
              widget.act==activity.Meetings?NoImageCard(ColorsApp.BackWidgetColor,10):Container(),

            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderTab(2, "Comments",mediaquery,Viewsection .Comment),
              Visibility(
                visible: state.viewsection==Viewsection.Comment,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 500,
                      width: mediaquery.size.width,


                      child:     CommentsScreen(activityId: context.read<AcivityFBloc>().state.activityById!.id)

                      ),
                ),
              )
            ],
          ),
          NoImageCard(ColorsApp.BackWidgetColor,10),
          // Header with three containers
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderTab(2, "Votes",mediaquery,   Viewsection.Poll,   icon: Icons.add,onPressed: (){
                  context.read<PollBloc>().add(CancelPollEvent());
                  context.read<PollBloc>().add(GetPollsAsTemplates());

                  showDialog(context: context, builder: (ctx)=>AddPollDialog(ActivityId: context.read<AcivityFBloc>().state.activityById!.id ,));


              }),   Visibility(
                  visible: state.viewsection==Viewsection.Poll,
                  child: SizedBox(child: PollImpl(activityId: context.read<AcivityFBloc>().state.activityById!.id,))),
            ],
          ),
          // PageView for content
          NoImageCard(ColorsApp.BackWidgetColor,10),

        ],
    );
  },
);
  }
  Widget _buildAgendaSection(MediaQueryData mediaQuery,PageIndexState state) {
    return    Visibility(
       visible: state.viewsection==Viewsection.Agenda,
        child: AgendaWidget(activity:  (context.read<AcivityFBloc>().state.activityById) as MeetingModel,));
  }

  // Build header tabs with bottom border
  Widget _buildHeaderTab(int index, String text,MediaQueryData med, Viewsection view,{IconData? icon,Function()? onPressed}  ) {
    return BlocBuilder<PageIndexBloc, PageIndexState>(
  builder: (context, state) {
    return Padding(
      padding:  EdgeInsets.all(3.0.sp),
      child: InkWell(
        onTap: () {
          if (state.viewsection!=view) {
            context.read<PageIndexBloc>().add(ChangeViewSectionEvent(viewsection: view));
          }
          else{
            context.read<PageIndexBloc>().add(ChangeViewSectionEvent(viewsection: Viewsection.Initial));
          }
        },
        child: Container(
          width:  med.size.width,
          decoration: const BoxDecoration(


            border: Border(
                bottom: BorderSide(
                  color:  ColorsApp.BackWidgetColor,
                  width: 2,
                )),

          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text,
                  style:PoppinsSemiBold(15.sp, Colors.black,TextDecoration.none),
                ),
                Row(
                  children: [
                    IconButton(onPressed: (){
                      if (state.viewsection!=view) {
                        context.read<PageIndexBloc>().add(ChangeViewSectionEvent(viewsection: view));
                      }
                      else{
                        context.read<PageIndexBloc>().add(ChangeViewSectionEvent(viewsection: Viewsection.Initial));
                      }
                    }, icon: Icon(state.viewsection==view?Icons.arrow_upward:Icons.arrow_downward_sharp)),

                    icon!=null?IconButton.outlined(icon:Icon(icon), onPressed: () {
                    onPressed!();

                  }, ):Container()
                    ]),

              ],
            ),
          ),
        ),
      ),
    );
  },
);
  }

  // Build content for each page
  Widget _buildAboutSection(MediaQueryData mediaQuery,PageIndexState state) {
    return Visibility(
      visible: state.viewsection==Viewsection.About,
      child: BlocBuilder<AcivityFBloc, AcivityFState>(
        builder: (context, state) {
      return SingleChildScrollView(
        child: Padding(
          padding:paddingSemetricVertical(v: 17.h),
          child: ActivityDetailsComponent.infoCircle(
            mediaQuery,
            state.activityById!,
            context


          ),
        ),
      );
        },
      ),
    );
  }
}