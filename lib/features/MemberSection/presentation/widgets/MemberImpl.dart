import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberPermissions/member_permission_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/MemberSection.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/SettingsComponents.dart';

import '../../../Home/presentation/widgets/ErrorDisplayMessage.dart';
import 'BestMembersWidget.dart';
import 'ShimmerEffects.dart';

class MemberImpl{

  static Widget MemberWidget(String id) {
    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        switch (state.userStatus) {
          case UserStatus.Loading:
            return ShimmerGridView.UserprofileShimmer(context);

          case UserStatus.userLoaded:
          case UserStatus.MemberByname:
          case UserStatus.MembersLoaded:
          case UserStatus.MembersRanksLoaded:
            return MemberSectionWidget(member: state.user!);
          case UserStatus.Error:
            context.read<MembersBloc>().add(GetUserProfileEvent(false));

            return SettingsComponent.signoput(context);
          default:
            return ShimmerGridView.UserprofileShimmer(context);
        }
      },
    );
  }
  static BlocBuilder<MembersBloc, MembersState> MembersAdminWidget(MediaQueryData mediaQuery) {
    return BlocBuilder<MembersBloc,MembersState>(builder: (context,state){

      switch (state.userStatus) {
        case UserStatus.Loading:
          return ShimmerGridView();
        case UserStatus.MembersLoaded:
        case UserStatus.MemberByname:
        case UserStatus.MembersRanksLoaded:
        case UserStatus.userLoaded:
        case UserStatus.ErrorMembers:


          return Column(
            children: [
              SizedBox(
                height: 200,
                child: ProfileComponents.MembersDetailsOnly(
                  state.memberByName,
                  mediaQuery,
                ),
              ),
            ],
          );
        default:
          return ShimmerGridView();
      }

    });
  }
  static BlocBuilder<MembersBloc, MembersState> MembersWithRanks(MediaQueryData mediaQuery) {
    return BlocBuilder<MembersBloc,MembersState>(builder: (context,state){

      switch (state.userStatus) {
        case UserStatus.Loading:
          return ShimmerGridView();
        case UserStatus.MembersLoaded:
        case UserStatus.MemberByname:
        case UserStatus.MembersRanksLoaded:
        case UserStatus.userLoaded:


          return BestMembersComponent.MembersRanksBody(context, state.membersWithRanks,);
        default:
          return ShimmerGridView();
      }

    });
  }
  static BlocBuilder<MembersBloc, MembersState> MemberWithHighestRanks(MediaQueryData mediaQuery) {
    return BlocBuilder<MembersBloc,MembersState>(builder: (context,state){

      switch (state.userStatus) {
        case UserStatus.Loading:
          return ShimmerGridView();
        case UserStatus.MembersLoaded:
        case UserStatus.MemberByname:
        case UserStatus.MembersRanksLoaded:
        case UserStatus.userLoaded:

if (state.memberWithRank == null) {
  context.read<MembersBloc>().add(
      GetMemberByHighestRAnkEvent(isUpdated: true));
  return ShimmerGridView();
}
          return BestMembersComponent.showHighestRankMembers(context, state.memberWithRank!,);
        default:
          context.read<MembersBloc>().add(
              GetMemberByHighestRAnkEvent(isUpdated: true));
          return ShimmerGridView();
      }

    });
  }
  static Widget Isowner(Widget isowner,bool pool){
  return  BlocBuilder<MemberPermissionBloc , MemberPermissionState>(
      builder: (context, state) {


       if (state.isowner && pool) {

         return isowner;
       }
       else {
         return SizedBox();
       }},
    );
  }
  static Widget IsNonowner(Widget isowner,){
  return  BlocBuilder<MemberPermissionBloc , MemberPermissionState>(
      builder: (context, state) {


       if (!state.isowner ) {

         return isowner;
       }
       else {
         return SizedBox();
       }},
    );
  }
    static Widget iSSuperNoowner(Widget isowner,bool pool){
  return  BlocBuilder<MemberPermissionBloc , MemberPermissionState>(
      builder: (context, state) {
       if (!state.isowner && state.isSuperAdmin) {

         return isowner;
       }
       else {
         return SizedBox();
       }},
    );
  }

}