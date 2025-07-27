import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/MemberSection/domain/usecases/MemberUseCases.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberPermissions/member_permission_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/member/MemberSection.dart';
import 'package:jci_app/features/MemberSection/presentation/components/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/components/SettingsComponents.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../functions/functionMember.dart';
import '../MemberFeatures/BestMembersWidget.dart';
import '../utils/ProfilShimmer.dart';
import '../utils/ShimmerEffects.dart';
import 'UsersList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberImpl {
  // Common widget for showing loading state
  static Widget _buildLoadingState() => const ShimmerListView();

  // Main member widget with refresh functionality
  static Widget memberWidget(String id, GlobalKey<ScaffoldState> scaffoldKey) {
    return BlocConsumer<MembersBloc, MembersState>(
      listener: (context, state)async {
        if (state.userStatus == UserStatus.Error) {
          FunctionMember.     IfCurrentOwner(context, id);
        }
      },
      builder: (context, state) {
        return _buildMemberContent(state, scaffoldKey,context,id);
      },
    );
  }



  static Widget _buildMemberContent(MembersState state, GlobalKey<ScaffoldState> scaffoldKey,BuildContext context,String id) {
    switch (state.userStatus) {
      case UserStatus.Loading:
        return const ProfileShimmer();
      case UserStatus.userLoaded:
      case UserStatus.MemberByname:
      case UserStatus.MembersLoaded:
      case UserStatus.MembersRanksLoaded:
        return RefreshIndicator(
          onRefresh: () async{
            FunctionMember.   IfCurrentOwner(context, id);
          },
          child: MemberSectionWidget(
            member: state.user!,
            scaffoldKey: scaffoldKey,
          ),
        );
      case UserStatus.Error:
        return SettingsComponent.signoput(context);
      default:
        return const ProfileShimmer();
    }
  }

  // Admin member list widget
  static Widget membersAdminWidget() {
    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        return _buildAdminContent(state,context);
      },
    );
  }

  static Widget _buildAdminContent(MembersState state,BuildContext context) {
    if (_isLoadingState(state.userStatus)) {
      return _buildLoadingState();
    }

    if (_isValidDataState(state.userStatus)) {
      return RefreshIndicator(
        onRefresh: () async{
          context.read<MembersBloc>().add(const GetAllMembersEvent(false));

        },
        child: MembersDetailsOnly(
          members: state.memberByName,
          isSearchMode: false,
        ),
      );
    }

    return _buildLoadingState();
  }

  // Members with ranks widget
  static Widget membersWithRanks(MediaQueryData mediaQuery) {
    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        return _buildRanksContent(state, context);
      },
    );
  }

  static Widget _buildRanksContent(MembersState state, BuildContext context) {
    if (_isLoadingState(state.userStatus)) {
      return _buildLoadingState();
    }

    if (_isValidDataState(state.userStatus)) {
      return BestMembersComponent.MembersRanksBody(
        context,
        state.membersWithRanks,
      );
    }

    return _buildLoadingState();
  }

  // Highest rank member widget
  static Widget memberWithHighestRanks(MediaQueryData mediaQuery) {
    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        return _buildHighestRankContent(state, context);
      },
    );
  }

  static Widget _buildHighestRankContent(MembersState state, BuildContext context) {
    if (_isLoadingState(state.userStatus) || state.memberWithRank == null) {
      return _buildLoadingState();
    }

    if (_isValidDataState(state.userStatus)) {
      return BestMembersComponent.showHighestRankMembers(
        context,
        state.memberWithRank!,
      );
    }

    return _buildLoadingState();
  }

  // Permission-based widgets
  static Widget isOwner(Widget child, bool pool) {
    return _buildPermissionWidget(
          (state) => state.isowner && pool,
      child,
    );
  }

  static Widget isNonOwner(Widget child) {
    return _buildPermissionWidget(
          (state) => !state.isowner,
      child,
    );
  }

  static Widget isSuperNonOwner(Widget child, bool pool) {
    return _buildPermissionWidget(
          (state) => !state.isowner && state.isSuperAdmin,
      child,
    );
  }

  static Widget _buildPermissionWidget(
      bool Function(MemberPermissionState) condition,
      Widget child,
      ) {
    return BlocBuilder<MemberPermissionBloc, MemberPermissionState>(
      builder: (context, state) {
        if (state.isLoading) return const SizedBox();
        return condition(state) ? child : const SizedBox();
      },
    );
  }

  // Helper methods
  static bool _isLoadingState(UserStatus status) =>
      status == UserStatus.Loading;

  static bool _isValidDataState(UserStatus status) =>
      status == UserStatus.MembersLoaded ||
          status == UserStatus.MemberByname ||
          status == UserStatus.MembersRanksLoaded ||
          status == UserStatus.userLoaded;
}