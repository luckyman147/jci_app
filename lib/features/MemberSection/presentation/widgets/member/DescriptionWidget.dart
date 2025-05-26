import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/config/env/Constants.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/MemberFeatures/PointsWidget.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/functions/PermissionFunctions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import '../../bloc/memberBloc/member_management_bloc.dart';
import '../../components/ProfileComponents.dart';
import '../../functions/functionMember.dart';
import 'BottomShettMember.dart';
class DescriptionName extends StatelessWidget {
  final Member member;

  const DescriptionName({
    Key? key,
    required this.member,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNameText(),
        _buildVerificationBadge(context),
      ],
    );
  }

  Widget _buildNameText() {
    return AutoSizeText(
      '${member.firstName} ${member.lastName}',
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: PoppinsSemiBold(17.sp, textColorBlack, TextDecoration.none),
    );
  }

  Widget _buildVerificationBadge(BuildContext context) {
    if (member.is_validated) {
      return _buildVerifiedIcon();
    }
    return _buildVerificationButton(context);
  }

  Widget _buildVerifiedIcon() {
    return Padding(
      padding: paddingSemetricHorizontal(),
      child:  Icon(
        Icons.verified,
        size: 23,
        color: ColorsApp.PrimaryColor,
      ),
    );
  }

  Widget _buildVerificationButton(BuildContext context) {
    return AsyncComponents.buildFutureBuilder(
      IconButton(
        style: _verificationButtonStyle(),
        onPressed: () => _handleVerification(context),
        icon:  Icon(
          Icons.verified_outlined,
          size: 23,
          color: ColorsApp.PrimaryColor,
        ),
      ),
      PermissionType.canUpdate,
      Constants.MANAGE_MEMBERS,
    );
  }

  ButtonStyle _verificationButtonStyle() {
    return ButtonStyle(
      overlayColor: WidgetStateProperty.all(
        ColorsApp.PrimaryColor.withOpacity(0.1),
      ),
      surfaceTintColor: WidgetStateProperty.all(Colors.white),
    );
  }

  void _handleVerification(BuildContext context) {
    context.read<MemberManagementBloc>().add(
      validateMember(memberid: member.id!),
    );
  }
}
class DescriptionUser extends StatelessWidget {
  final Member member;

  const DescriptionUser({
    Key? key,
    required this.member,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: BlocBuilder<MemberManagementBloc, MemberManagementState>(
        builder: (context, state) {
          return _buildStatsRow(context, state);
        },
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, MemberManagementState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 10),
          _buildPointsStat(context, state),
_buildVerticalDivider(),
          _buildRankStat(),
_buildVerticalDivider(),

          _buildCotisationStat(context),
        ],
      ),
    );
  }

  Widget _buildPointsStat(BuildContext context, MemberManagementState state) {
    return StaticsContainer(
      number: state.points.ceil().toString(),
      text: "Points",
      color: ColorsApp.PrimaryColor,
      onTap: () => _handlePointsTap(context, state),
    );
  }

  Widget _buildRankStat() {
    return StaticsContainer(
      number: member.rank.toString(),
      text: "Rank",
      color: ColorsApp.SecondaryColor, onTap: () {  },
    );
  }

  Widget _buildCotisationStat(BuildContext context) {
    return BlocSelector<MemberManagementBloc, MemberManagementState, List<bool>?>(
  selector: (state) {
    return state.cotisation;
    // TODO: return selected state
  },
  builder: (context, state) {
    return StaticsContainer(
      number: "${FunctionMember.CalculateCotisation(state)}/${member.cotisation.length}",
      text: "Cotisation",
      color: Colors.green, onTap: () {
       BottomMemberSheet. showBottomCotisationSheet(context,member);
    },
    );
  },
);
  }

  Widget _buildVerticalDivider() {
    return const SizedBox(
      height: 70,
      width: 20,
      child: VerticalDivider(
        thickness: 5,
        color: ColorsApp.textColorWhite,
      ),
    );
  }

  void _handlePointsTap(BuildContext context, MemberManagementState state) {
    final permissionState = context.read<PermissionsBloc>().state;
    final hasPermission = PermissionsFunctions.HasPermission(
      permissionState,
      Constants.MANAGE_POINTS,
      PermissionType.canUpdate,
    );

    if (hasPermission) {
      PointsWidget.show(context, member, state, FocusNode());
    }
  }
}