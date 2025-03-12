import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../../domain/enums/SearchType.dart';

import '../../components/ErrorDisplayMessage.dart';
import '../MembersFunctions.dart';
import 'MemberDetails.dart';



class MembersFetchWidget extends StatelessWidget {

  final String name;

  const MembersFetchWidget({
    Key? key,

    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MembersBloc, MembersState>(
      builder: (context, state) {
        switch (state.userStatus) {
          case UserStatus.Loading:
            return const LoadingWidget();

          case UserStatus.MembersLoaded:
            return _buildMembersLoaded(context, state);

          case UserStatus.MemberByname:
            return _buildMemberByName(context, state, name);

          case UserStatus.Error:
            return MessageDisplayWidget(message: state.Errormessage);

          default:
            return const LoadingWidget();
        }
      },
      listener: (BuildContext context, MembersState state) {
        if (state.userStatus == UserStatus.Error) {
          context.read<MembersBloc>().add(const GetAllMembersEvent(true));
        }
      },
    );
  }

  Widget _buildMembersLoaded(BuildContext context, MembersState state) {
    return RefreshIndicator(
      onRefresh: () async {
        await RefreshMembers(context, SearchType.All, "");
      },
      child: MembersDetailsWidget(members:  state.members),
    );
  }

  Widget _buildMemberByName(BuildContext context, MembersState state, String name) {
    if (name.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          await RefreshMembers(context, SearchType.Name, name);
        },
        child: MembersDetailsWidget(members:state.memberByName),
      );
    } else {
      context.read<MembersBloc>().add(const GetAllMembersEvent(true));
      return const LoadingWidget(); // Return loading if name is empty
    }
  }
}
