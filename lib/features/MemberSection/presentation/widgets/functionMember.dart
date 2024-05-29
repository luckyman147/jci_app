import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/Teams/presentation/widgets/funct.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../../core/config/services/MemberStore.dart';
import '../../../Teams/domain/entities/Team.dart';
import '../../domain/repositories/MemberRepo.dart';
import '../../domain/usecases/MemberUseCases.dart';
import '../bloc/Members/members_bloc.dart';

class FunctionMember{
  static int CalculateCotisation(List<bool> bools)=>
      bools.fold(0, (previousValue, element) => previousValue+(element?1:0));

static int calculateObjectifs(List<dynamic> bools)=>
    bools.fold(0, (previousValue, element) => previousValue+(element['Condition']?1:0));
static Future<List<Member>> getMembers(){
  return MemberStore.getCachedMembers();
}
  static bool CheckBoolAtIndex(List<bool> bools, int index) {
    if (index >= 0 && index < bools.length) {
      return bools[index];
    } else {
      throw RangeError.range(index, 0, bools.length - 1, 'Index out of range');
    }
  }

  static savePoints(String id,double points, BuildContext context) {
  final updatePointsParams = UpdatePointsParams(memberid: id, points: points);
    context.read<MemberManagementBloc>().add(UpdatePoints(updatePointsParams: updatePointsParams));
  }
  static UpdateCotisationAction(String id, int type, bool cotisation, BuildContext context) {
    final updateCotisationParams = UpdateCotisationParams(memberid: id, type: type, cotisation: cotisation);
    context.read<MemberManagementBloc>().add(UpdateCotisation(updateCotisationParams: updateCotisationParams));
  }

  static Future<dynamic>  saveMember(Member member,TextEditingController firstName,
      TextEditingController lastName,TextEditingController phone,
      String imagepath,BuildContext context,GlobalKey<FormState> formKey,TextEditingController description

      )async {

      if     (!formKey.currentState!.validate()) {
        return;
      }
      else {
        final memberUpdate = Member(
          id: member.id,
          firstName: firstName.text,
          lastName: lastName.text,
          phone: phone.text,
          email: member.email,
          Images: [imagepath],
          cotisation: member.cotisation,
          teams: member.teams,
          Activities: member.Activities,
          points: member.points,
          IsSelected: member.IsSelected,
          role: 'New Member                                                                 ',
          is_validated: member.is_validated,
          password: 'password', objectifs: [], language: member.language, rank: 0, description:description.text, board: member.board ,
        );
        context.read<MembersBloc>().add(
            UpdateMemberProfileEvent(memberUpdate));
        formKey.currentState!.reset();
        context.read<MembersBloc>().add(GetUserProfileEvent(true));


      }

  }
  static void ChangeRole(String id, MemberType type, BuildContext context) {
    final changeToAdminParams = ChangeRoleParams(id: id, type: type);
    context.read<MemberManagementBloc>().add(ChangeRoleEvent( changeToAdminParams));
  }

static Future<bool> isAdminAndSuperAdmin()async{
  final member = await MemberStore.getModel();
  return member!.role=='admin' || member.role=='superadmin';
}
static Future<bool> isSuper()async{
  final member = await MemberStore.getModel();
  return member!.role=='superadmin';
}

static Future<bool> isSuperAdminANdNoOwner(Member other)async {
  final member = await MemberStore.getModel();
  return member!.role == 'superadmin' && member.id!=other.id ;
}
static Future<bool> isSuperAdmin( Member other)async{

  return other.role=='superadmin';}
static Future<bool> isReAdmin(Member other)async {

  return other.role=='admin' ;
}

  static bool isChef(Team team, int index) => Member.toMember(team.Members[index]).id!= Member.toMember(team.TeamLeader[0]).id;
static Future<bool> isChefAndSuperAdmin(Team team,)async {
  final member = await MemberStore.getModel();
  return Member.toMember(team.TeamLeader[0]).id==member!.id || member!.role=='superadmin'|| member.role=='admin';
}
 static  bool checkIfIdExists(List<Member> list, String idToCheck) {
  if (list.isEmpty) {
    return false;
  }
 final   result= list.any((map) =>  map.id== idToCheck);
log("result $result");
  return result;
}
static Future<bool > ischefAndExisted(Team team)async{
  final  member=await MemberStore.getModel();

  return checkIfIdExists(team.Members.map((e) => Member.toMember(e)).toList(), member!.id)&& await isChefAndSuperAdmin(team);
}


static Future<bool> isAssignedOrLoyal(Team team, List<dynamic> assignT)async {
  final  member=await MemberStore.getModel();
  return checkIfIdExists(assignT.map((e) => Member.toMember(e)).toList(), member!.id) || await isChefAndSuperAdmin(team);
}

  static Future<bool> IsNotExistedAndPublic(Team team) async {
    final  member=await MemberStore.getModel();
    final result=!checkIfIdExists(team.Members.map((e) => Member.toMember(e)).toList(), member!.id);log('message'+result.toString());

    return TeamFunction.IsPublic(team) &&result ;
  }
  static Future<bool> isOwner(String id)async {
    final member =await MemberStore.getModel();

    return member!.id == id;
  }
static Future<bool> isMember(Member merber)async {

  return merber.role=='member';
}
  static void Showinfo(BuildContext context, Member member) {
    showModalBottomSheet(
        showDragHandle: true,
        context: context, builder: (context){

      return SizedBox(
        height: 200,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            member.phone.isNotEmpty?
          ProfileComponents.  BuildInfoRow( Icons.phone, member.phone):SizedBox(),
            SizedBox(height: 10,),
        ProfileComponents.    BuildInfoRow( Icons.email, member.email),

          ],),
      );
    });
  }

}