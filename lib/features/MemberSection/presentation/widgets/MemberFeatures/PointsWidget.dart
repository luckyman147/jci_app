import 'package:flutter/material.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../core/Member.dart';
import '../../../../../core/app_theme.dart';
import '../../bloc/memberBloc/member_management_bloc.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import '../member/BottomShettMember.dart';
import '../member/functionMember.dart';

class PointsWidget extends StatelessWidget {
  final Member member;
  final MemberManagementState state;
  final FocusNode pointsFocusNode;

  const PointsWidget({
    Key? key,
    required this.member,
    required this.state,
    required this.pointsFocusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Column(
        children: [
          const _PointsHeader(),
          _PointsDetails(state: state),
          const SizedBox(height: 10),
          _EditPointsButton(member: member, pointsFocusNode: pointsFocusNode),
          _RankWidget(member: member),
        ],
      ),
    );
  }
}

class _PointsHeader extends StatelessWidget {
  const _PointsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total Points', style: PoppinsRegular(18, textColor)),
        Text('Cotisation'.tr(context), style: PoppinsRegular(18, textColor)),
      ],
    );
  }
}

class _PointsDetails extends StatelessWidget {
  final MemberManagementState state;

  const _PointsDetails({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricHorizontal(h: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: paddingSemetricHorizontal(h: 20),
            child: Text(
              state.points.toInt().toString(),
              style: PoppinsSemiBold(25, textColorBlack, TextDecoration.none),
            ),
          ),
          Text(
            "${FunctionMember.CalculateCotisation(state.cotisation)}/${state.cotisation.length}",
            style: PoppinsSemiBold(25, textColorBlack, TextDecoration.none),
          ),
        ],
      ),
    );
  }
}

class _EditPointsButton extends StatelessWidget {
  final Member member;
  final FocusNode pointsFocusNode;

  const _EditPointsButton({required this.member, required this.pointsFocusNode});

  @override
  Widget build(BuildContext context) {
    return AsyncComponents.buildFutureBuilder(
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton.outlined(
            onPressed: () {
              BottomMemberSheet.showBottomSheet(context, member, pointsFocusNode);
            },
            icon: const Icon(Icons.edit, size: 20),
          ),
        ],
      ),
        PermissionType.canUpdate,""
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
        PermissionType.canUpdate,""
    );
  }
}
