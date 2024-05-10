
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/BoardBloc/boord_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/YearsBloc/years_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/AssignToWidget.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/BoardComponents.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/ShimmerEffects.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/YearsButtons.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../Domain/entities/President.dart';
import 'BoardRoles.dart';
import 'BoardWidget.dart';
import 'PresComponents.dart';

class BoardImpl{

  static Widget GetYearsComponent(BuildContext context,ScrollController scrollController){
    return BlocConsumer<YearsBloc,YearsState>(
      builder: (context,state){
      switch(state.state){
        case yearsStates.Loading:
          return ShimmerPostsWidget();

        case yearsStates.Loaded:
          case yearsStates.Changed:
          case yearsStates.ChangedPosition:
            case yearsStates.ErrorRole:
            case yearsStates.ErrorChanged:
              case yearsStates.Roles:


        return YearsButtons(scrollController, state.years);
        case yearsStates.Error:
          return ShimmerPostsWidget();

          default:

          return ShimmerPostsWidget();
      }
      }, listener: (BuildContext context, YearsState state) {
        if (state.state == yearsStates.Loaded) {
          context.read<BoordBloc>().add(FetchBoardYearsEvent(year: state.years[0]));

        }
        else if (state.state == yearsStates.ChangedPosition)

{
  SnackBarMessage.showSuccessSnackBar(
      message: state.message, context: context);
          context.read<BoordBloc>().add(FetchBoardYearsEvent(year: state.year));
}
    },
    );

  } static Widget GetBoardRolesComponent(BuildContext context){
    return BlocConsumer<YearsBloc,YearsState>(
      builder: (context,state){
      switch(state.state){



              case yearsStates.Roles:
                case yearsStates.Changed:
                  case yearsStates.ErrorChanged:
                  case yearsStates.ChangedPosition:


        return BoardRolesDropButton(items: state.roles,);
        case yearsStates.ErrorRole:
          return ShimmerMember();

          default:

          return ShimmerMember();
      }
      }, listener: (BuildContext context, YearsState state) {



    },
    );

  }
  static Widget GetBoardComponent(PageController pageController){
    return BlocBuilder<BoordBloc,BoordState>(
      builder: (context,state){
      switch(state.state){
        case BoardStatus.Loading:
          return ShimmerEffects.ShimmerYearsButton();

        case BoardStatus.Loaded:
          case BoardStatus.Changed:

          return BoardYearPostsWidget( posts: state.boardYears[0].posts, pageController: pageController,);
        case BoardStatus.Error:
          return ShimmerEffects.ShimmerYearsButton();


        default:

          return ShimmerEffects.ShimmerYearsButton();

      }
      },
    );

  }


  static Widget  AssignToWidget(String postid){
    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        if (state is MembersInitial) {
          return ShimmerMember();
        } else if (state.userStatus == UserStatus.MembersLoaded) {
          return ShimmerMember();

        }

        else if (state.userStatus == UserStatus.MembersLoaded ) {
          return MemberGridView(members:state.members, postId: postid,);
        }
        else if (state .userStatus == UserStatus.MemberByname) {

          return MemberGridView(members:state.memberByName, postId: postid,);
        } else if (state .userStatus==UserStatus.Error) {
          return ShimmerMember();
        }
        return ShimmerMember();
      },
    );
  }

}