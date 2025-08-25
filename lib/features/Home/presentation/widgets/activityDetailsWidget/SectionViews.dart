import 'package:auto_size_text/auto_size_text.dart';
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
  final String id;

  const SectionViewer({super.key, required this.act, required this.id});
  @override
  _SectionViewerState createState() => _SectionViewerState();
}

class _SectionViewerState extends State<SectionViewer> {
  final PageController _pageController = PageController();
  int selectedPageIndex = 0;

  void onTabSelected(int index) {
    setState(() => selectedPageIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);


    final tabs = [
      'About',
      if (widget.act == activity.Meetings) 'Agenda',
      if (widget.act == activity.Meetings) 'PV',
      'Comments',
      'Votes',
    ];

    return Column(
      children: [
        // 🔹 Header Tabs Row
    Container(

      decoration: BoxDecoration(



      ),
        child:     SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment:  CrossAxisAlignment.center,

          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(tabs.length, (index) {
            return _buildHeaderTab(
           index:    index,
            selectedIndex:selectedPageIndex,
              text: tabs[index],


              onTap: () => onTabSelected(index),
            );
          }),
        ))),
        const SizedBox(height: 8),

        // 🔹 Content Area
        SizedBox(
          height: mediaquery.size.height * 0.7,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => selectedPageIndex = index);
            },
            children: [
              // Page 0 - About
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAboutSection(mediaquery),

                  ActivityDetailsComponent.Description(
                      mediaquery,
                      context.read<AcivityFBloc>().state.activityById!,

                  ),
                 Padding(padding: paddingSemetricVerticalHorizontal(),child:  Text(
                    "Categories",
                    style: PoppinsSemiBold(
                        19, ColorsApp.textColorBlack, TextDecoration.none),
                  )),

                  buildCategories( context.read<AcivityFBloc>().state.activityById!)
                ],
              ),

              // Page 1 - Agenda
              if (widget.act == activity.Meetings)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAgendaSection(mediaquery,),
                  ],
                ),

              // Page 2 - PV
              if (widget.act == activity.Meetings)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                       SizedBox(
                        width: mediaquery.size.width,
                        child: PVImpl(
                          activityId: context
                              .read<AcivityFBloc>()
                              .state
                              .activityById!
                              .activityBasics
                              .id,
                        ),
                      ),

                  ],
                ),

              // Page 3 - Comments
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(

                        width: mediaquery.size.width,
                        child: CommentsScreen(
                          activityId: context
                              .read<AcivityFBloc>()
                              .state
                              .activityById!
                              .activityBasics
                              .id,
                          id: widget.id,
                        ),
                      ),
                    ),

                ],
              ),

              // Page 4 - Poll
              SingleChildScrollView(
                child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                 PollImpl(
                      activityId: context
                          .read<AcivityFBloc>()
                          .state
                          .activityById!
                          .activityBasics
                          .id, eventType: widget.act,
                    ),

                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
   Padding buildCategories( Activity activity) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: activity.settings.categoryIds.map((category) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              decoration: BoxDecoration(
           border: Border.all(color: ColorsApp.ThirdColor),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: AutoSizeText(
                "#$category",
                style: PoppinsSemiBold(14.sp, ColorsApp.ThirdColor, TextDecoration.none),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAgendaSection(MediaQueryData mediaQuery) {
    return
         AgendaWidget(
          activity:
              (context.read<AcivityFBloc>().state.activityById) as MeetingModel,
        );
  }

  // Build header tabs with bottom border
  Widget _buildHeaderTab({
    required int index,
    required int selectedIndex,
    required String text,
    required VoidCallback onTap,
  }) {
    final isSelected = index == selectedIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? ColorsApp.PrimaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: AutoSizeText(
            text,
            style: PoppinsSemiBold(14.sp,
          isSelected ? ColorsApp.textColorWhite : ColorsApp.textColorBlack,
        TextDecoration.none
            ),
          ),
        ),
      ),
    );
  }


  // Build content for each page
  Widget _buildAboutSection(MediaQueryData mediaQuery,) {
    return
       BlocBuilder<AcivityFBloc, AcivityFState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: paddingSemetricVertical(v: 17.h),
              child: ActivityDetailsComponent.infoCircle(
                  mediaQuery, state.activityById!, context),
            ),
          );
        },

    );
  }
}
