import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/components/ProfileComponents.dart';
import 'package:jci_app/core/Member.dart';

import '../../../../core/PrimitiveUser/User.dart';
import '../../../../core/config/services/MemberStore.dart';
import '../../../../core/config/services/store.dart';
import '../../../Teams/domain/entities/Team/Team.dart';
import '../../domain/repositories/MemberRepo.dart';
import '../../domain/usecases/AdminMembersUsesCase.dart';
import '../../domain/usecases/MemberUseCases.dart';
import '../bloc/Members/members_bloc.dart';
import '../bloc/memberPermissions/member_permission_bloc.dart';

class FunctionMember {
  final Store store;

  FunctionMember({required this.store});
  static int CalculateCotisation(List<bool>? bools) {
    if (bools==null) {
      return 0;
    }

    return bools.fold(
      0, (previousValue, element) => previousValue + (element ? 1 : 0));
  }

  static int calculateObjectifs(List<dynamic> bools) => bools.fold(
      0,
      (previousValue, element) =>
          previousValue + (element['Condition'] ? 1 : 0));
  static Future<List<User>> getMembers() {
    return MemberStore.getCachedMembers();
  }

  static bool CheckBoolAtIndex(List<bool> bools, int index) {
    if (index >= 0 && index < bools.length) {
      return bools[index];
    } else {
      throw RangeError.range(index, 0, bools.length - 1, 'Index out of range');
    }
  }

  static void IfCurrentOwner(BuildContext context, String id) {
    final currentowner = context.read<MemberPermissionBloc>().state.isowner;
    if (currentowner) {
      context.read<MembersBloc>().add(const GetUserProfileEvent(false));
    } else {
      context
          .read<MembersBloc>()
          .add(GetMemberByIdEvent(MemberInfoParams(id: id, status: true)));
    }
  }

  static savePoints(String id, double points, BuildContext context) {
    final updatePointsParams = UpdatePointsParams(memberid: id, points: points);
    context
        .read<MemberManagementBloc>()
        .add(UpdatePoints(updatePointsParams: updatePointsParams));
    Navigator.pop(context);
  }

  static UpdateCotisationAction(
      String id, int type, bool cotisation, BuildContext context) {
    final updateCotisationParams = UpdateCotisationParams(
        memberid: id, type: type, cotisation: cotisation);
    context
        .read<MemberManagementBloc>()
        .add(UpdateCotisation(updateCotisationParams: updateCotisationParams));
  }

  static Future<dynamic> saveMember(
      Member member,
      TextEditingController firstName,
      TextEditingController lastName,
      TextEditingController phone,
      String imagepath,
      BuildContext context,
      GlobalKey<FormState> formKey,
      TextEditingController description) async {
    if (!formKey.currentState!.validate()) {
      return;
    } else {
      final memberUpdate = Member(
        id: member.id!,
        firstName: firstName.text,
        lastName: lastName.text,
        phone: phone.text,
        email: member.email,
        Images: [imagepath],
        cotisation: member.cotisation,
        teams: member.teams,
        Activities: member.Activities,
        points: member.points,
        PreviousPoints: member.PreviousPoints,
        IsSelected: member.IsSelected,
        role: member.role,
        is_validated: member.is_validated,
        language: member.language,
        rank: 0,
        description: description.text,
        board: member.board,
        isEmailVerified: member.isEmailVerified,
        userObjectifs: [],
      );
      context.read<MembersBloc>().add(UpdateMemberProfileEvent(memberUpdate));
      formKey.currentState!.reset();
      context.read<MembersBloc>().add(const GetUserProfileEvent(true));
    }
  }



  static bool isChef(Team team, int index) =>
      team.members.members[index].user.id !=
      team.members.teamLeader!.id;

  static bool checkIfIdExists(List<Member> list, String idToCheck) {
    if (list.isEmpty) {
      return false;
    }
    final result = list.any((map) => map.id == idToCheck);
    log("result $result");
    return result;
  }

  Future<bool> isOwner(String id) async {
    final member = await store.getUserId();

    return member == id;
  }

  static void Showinfo(BuildContext context, Member member) {
    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                member.phone.isNotEmpty
                    ? ProfileComponents.BuildInfoRow(Icons.phone, member.phone)
                    : const SizedBox(),
                const SizedBox(
                  height: 10,
                ),
                ProfileComponents.BuildInfoRow(Icons.email, member.email),
              ],
            ),
          );
        });
  }
}
