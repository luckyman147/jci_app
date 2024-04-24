import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/YearsBloc/years_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../MemberSection/presentation/widgets/ProfileComponents.dart';
import '../../Domain/entities/Post.dart';

class BoardYearPostsWidget extends StatelessWidget {
  final List<List<Post>> posts;
  final PageController pageController ;

TextEditingController controller = TextEditingController();
  BoardYearPostsWidget({required this.posts, required this.pageController, });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: SizedBox(

          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, priorityIndex) {
                final postList = posts[priorityIndex];
        
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Priority ${priorityIndex + 1}".tr(context),
                        style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none  ),
                      ),
                    ),
                    buildGridView(postList,priorityIndex+1,)
                  ],
                );
              },
            ),
        ),
      ),
    );
  }

  Widget buildGridView(List<Post> postList,int priority) {
    return BlocBuilder<YearsBloc, YearsState>(
  builder: (context, state) {
    return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2, // Number of columns
                      childAspectRatio: .8, // Aspect ratio of items
                    ),
                    itemCount: postList.length+1,
                    itemBuilder: (context, postIndex) {
                      if (postIndex == postList.length) {
                        // This is the last item, return the button
                     return   ProfileComponents.buildFutureBuilder(
                         BuiklAddBoardRole(context,priority,state.year)

                         , true, "id", (p0) => FunctionMember.isSuper());
                      } else {
                        final post = postList[postIndex];
                        return ChildBody(post, context);
                      }
                    },
                  );
  },
);
  }

  InkWell BuiklAddBoardRole(BuildContext context,int prio,String year,) {
    return InkWell(
                         onTap: (){
                            context.read<YearsBloc>().add(GetBoardRolesEvent(priority: prio));
                           JCIFunctions.showAddPosition(context,pageController);
                         },
                         child: DottedBorder(
                           radius: Radius.circular(10),
                           dashPattern:const  [21,17,21,17],
                                                      color: textColor,
                           strokeWidth: 2,
                            borderType: BorderType.RRect,
                           child: Center(
                             child:  Icon(Icons.add,color: textColor,size: 50,),
                           ),
                         ),
                       );
  }

  InkWell ChildBody(Post post, BuildContext context) {
    return InkWell(
      onTap: () {

        context.read<MembersBloc>().add(GetAllMembersEvent());
        JCIFunctions.showPosAction(context,post,controller);
      },
      onDoubleTap: (){


      },
      child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: textColorBlack, width: 2),
                            ),



                            child: Padding(
                              padding: paddingSemetricVerticalHorizontal(v: 15),
                              child: getPOSTWidget(post, context),
                            )),
    );
  }
  Widget getPOSTWidget(Post post, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(

            child: Column(
              children: [

                post.assignTo.isNotEmpty?
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(child: pho(post, context)),
                    Text(post.assignTo.first.firstName,
                      textAlign: TextAlign.center,
                      style:
                      PoppinsRegular(16, textColorBlack, )
                      ,),
                  ],
                ):SizedBox(),
                Text(" ${post.role}",
                  textAlign: TextAlign.center,
                  style:PoppinsSemiBold(MediaQuery.of(context).devicePixelRatio*5, textColorBlack, TextDecoration.none)
                  ,),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Container pho(Post post, BuildContext context) {
    return (post.assignTo.isEmpty)&&post.assignTo[0].Images==null|| post.assignTo[0].Images.isEmpty?Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          color: textColorWhite,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: textColor, width: 4.0),

        ),
        child:CircleAvatar(
          backgroundColor: textColorWhite,
          backgroundImage: AssetImage(vip),
        )
    ):
    Container(
      decoration: BoxDecoration(
        color: textColorWhite,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: textColor, width: 4.0),

      ),
      child: ProfileComponents.phot(post.assignTo[0].Images[0]["url"], context,110),
    );
  }

}

