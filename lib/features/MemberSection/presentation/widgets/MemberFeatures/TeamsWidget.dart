import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../core/Member.dart';
import '../../../../../core/app_theme.dart';
import '../../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../../Teams/data/models/TeamModel.dart';
import '../../../../Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import '../../../../Teams/presentation/widgets/DetailTeamComponents.dart';
import '../../../../Teams/presentation/widgets/TeamWidget.dart';
import '../member/functionMember.dart';

class TeamsComponent extends StatelessWidget {
  final Member member;


  const TeamsComponent({
    Key? key,
    required this.member,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.6,
        ),
        child: member.teams.isEmpty
            ? _buildAddTeamsWidget(context)
            : _buildTeamsList(mediaQuery.size.width / 2,mediaQuery),
      ),
    );
  }

  Widget _buildAddTeamsWidget(BuildContext context) {
    return AsyncComponents.buildFutureBuilder(
      AddTeamsWidget(context),
        PermissionType.canRead,""
    );
  }

  static Column AddTeamsWidget(BuildContext context) {
    return Column(
      children: [
        IconButton.outlined(icon:const Icon(Icons.add,size: 30,), onPressed: () {
          context.read<PageIndexBloc>().add(SetIndexEvent(index: 2));
          context.go('/home');
          context.read<GetTeamsBloc>().add(const GetTeams(isPrivate: false));
        },),
        const SizedBox(height: 10,),
        Text('Join Your first Team ',style: PoppinsRegular(17, textColorBlack),),
      ],);
  }

  Widget _buildTeamsList(double size,MediaQueryData medi) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return _buildTeamItem(index,medi
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          width: size ,
          child: const Divider(color: textColor, height: 12),
        );
      },
      itemCount: member.teams.length,
    );
  }

  Widget _buildTeamItem(int index,MediaQueryData mediaQuery) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTeamDetails(index,mediaQuery),
          IsPublic(member.teams[index]['status'])
        ],
      ),
    );
  }

  Widget _buildTeamDetails(int index,MediaQueryData mediaQuery) {
    return Row(
      children: [
        DeatailsTeamComponent.ImageCard(
          mediaQuery,
          TeamModel.fromJson(member.teams[index]).CoverImage,
          40,
        ),
        Padding(
          padding: paddingSemetricHorizontal(),
          child: SizedBox(
            width: mediaQuery.size.width / 2.5,
            child: Text(
              member.teams[index]['name'],
              overflow: TextOverflow.ellipsis,
              style: PoppinsRegular(17, textColorBlack),
            ),
          ),
        ),
      ],
    );
  }
}
