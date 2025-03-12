import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../core/Member.dart';
import '../../../../../core/app_theme.dart';
import '../../bloc/memberBloc/member_management_bloc.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'BottomShettMember.dart';
import 'MemberImpl.dart';
import 'functionMember.dart';

class DescriptionUser extends StatelessWidget {
  final Member member;

  const DescriptionUser({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 85,
      left: 0,
      right: 0,
      child: BlocBuilder<MemberManagementBloc, MemberManagementState>(
        builder: (context, state) {
          return Column(
            children: [
              DescriptionName(member: member, state: state),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    member.roleName.toString(),
                    style: PoppinsSemiBold(17, SecondaryColor, TextDecoration.none),
                  ),
                  MemberImpl.iSSuperNoowner(
                    IconButton(
                      onPressed: () {
                        BottomMemberSheet.ShowAdminChangeSheet(context, member);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    true,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class DescriptionName extends StatelessWidget {
  final Member member;
  final MemberManagementState state;

  const DescriptionName({Key? key, required this.member, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            '${member.firstName} ${member.lastName}',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none),
          ),
        ),
        state.isUpdated
            ? const Icon(Icons.verified, color: PrimaryColor)
            : AsyncComponents.buildFutureBuilder(
          IconButton(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(PrimaryColor.withOpacity(0.1)),
              surfaceTintColor: WidgetStateProperty.all(Colors.white),
            ),
            onPressed: () {
              context.read<MemberManagementBloc>().add(validateMember(memberid: member.id!));
            },
            icon: const Center(child: Icon(Icons.check_circle_outline, size: 25)),
          ),
            PermissionType.canUpdate,""
        ),
      ],
    );
  }
}
class BuildDescriptionWidget extends StatelessWidget {
  final Member member;

  const BuildDescriptionWidget({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                member.description,
                style: PoppinsRegular(18, textColorBlack),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
