import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis/shared.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import 'package:jci_app/core/config/env/Constants.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/functions/PermissionFunctions.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../core/Member.dart';
import '../../../../../core/app_theme.dart';
import '../../../../Home/Activity_Global.dart';
import '../../bloc/memberBloc/member_management_bloc.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import '../member/BottomShettMember.dart';
import '../../functions/functionMember.dart';
import 'ChangePoints.dart';

class PointsWidget extends StatelessWidget {
  final Member member;

  final FocusNode pointsFocusNode;

  const PointsWidget({
    Key? key,
    required this.member,

    required this.pointsFocusNode,
  }) : super(key: key);

  static void show(BuildContext context, Member member,
      MemberManagementState state, FocusNode node) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true, // Allow the bottom sheet to take up more space
      builder: (context) {
        return PointsWidget(member: member, pointsFocusNode: node);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      padding: paddingSemetricVerticalHorizontal(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // Ensure the column takes up minimal space
        children: [
          BlocBuilder<MemberManagementBloc, MemberManagementState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: textColor, width: 2)),
                title:   Center(
                  child: Text('Update Points', style: PoppinsSemiBold(17.sp
                      , ColorsApp.textColorBlack, TextDecoration.none),),
                ),

                  subtitle: ChangePoints(
                   mediaQuery:    mediaQuery, state: state,
                   id:   member.id!),

                ),
              );
            },
          ),
          // _RankWidget(member: member), // Uncomment if needed
        ],
      ),
    );
  }

}

class _RankWidget extends StatelessWidget {
  final Member member;

  const _RankWidget({required this.member});

  @override
  Widget build(BuildContext context) {
    return AsyncComponents.buildFutureBuilder(
      SizedBox(
        child: Padding(
          padding: paddingSemetricHorizontal(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Rank  ', style: PoppinsRegular(20, textColor)),
                  Text(
                    'NO.${member.rank}  ',
                    style: PoppinBold(
                      MediaQuery.of(context).devicePixelRatio * 6,
                      PrimaryColor,
                      TextDecoration.none,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.stars_rounded, color: PrimaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      PermissionType.canUpdate,
      Constants.MANAGE_POINTS,
    );
  }
}