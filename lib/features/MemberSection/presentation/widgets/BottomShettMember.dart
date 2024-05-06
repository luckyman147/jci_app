import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/MemberRepo.dart';
import 'package:jci_app/features/MemberSection/domain/usecases/MemberUseCases.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/PresWidgets.dart';

import '../../../auth/domain/entities/Member.dart';

class BottomMemberSheet {

  static showBottomSheet(BuildContext context, Member member, FocusNode pointsFocusNode) {
    showModalBottomSheet(

      isDismissible: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final mediaQuery = MediaQuery.of(context);
        return PointsCotisationSheet(mediaQuery, pointsFocusNode, member);
      },
    );
  }


  static ShowAdminChangeSheet (BuildContext context,Member member){
    showModalBottomSheet(
      isDismissible: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final mediaQuery = MediaQuery.of(context);
        return AdminChangeSheet(context,member);
      },
    );
  }

  static BlocBuilder<ChangeSboolsCubit, ChangeSboolsState> PointsCotisationSheet(MediaQueryData mediaQuery, FocusNode pointsFocusNode, Member member) {
    return BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
builder: (context, state) {

  return AnimatedContainer(
    height:state.IsActive ? 350 : 250,

        width: double.infinity,
        duration: Duration(milliseconds: 300),
        child: BlocBuilder<MemberManagementBloc, MemberManagementState>(
          builder: (context, state) {
            log("sdsss"+state.cotisation.toString());
            return Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: textColor, width: 2)),
                   title: ChangePoints(mediaQuery, state,  pointsFocusNode,context,member.id),

                  ),
                ),Row(
                  children: [
                    CotisationField(mediaQuery, state,"1st Cotisation",0,(valu){
                      FunctionMember.UpdateCotisationAction(member.id, 0, valu!,context);

                    }),
                    state.cotisation.length>1?
                    CotisationField(mediaQuery, state,"2nd Cotisation",1,(valu){
                      FunctionMember.UpdateCotisationAction(member.id, 1, valu!,context);

                    }):IconButton.outlined(onPressed: (){
                      context.read<MemberManagementBloc>().add(AddCotisation());
                    }, icon: Icon(Icons.add)),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: mediaQuery.size.width * 0.5,
                      child: PresWidgets.ButtonActions(context, BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                        width: 2,
                        color:textColor
                      )), Icons.card_membership_rounded, "Membership Report", () =>
                                  context.read<MemberManagementBloc>().add(SendMembershipReportEvent(id:member.id)),
                      ),
                    ),
                    SizedBox(
                      width: mediaQuery.size.width * 0.5,
                      child: PresWidgets.ButtonActions(context, BoxDecoration(border: Border.all(
                        width: 2,
                        color:textColor

                      ),borderRadius: BorderRadius.circular(15
                      )), Icons.report, "Inactivity Report", () =>
                                  context.read<MemberManagementBloc>().add(SendInactivityReportEvent(id:member.id)),
                      ),
                    ),
                  ],
                ),


              ],
            );
          },
        ),
      );
},
);
  }

  static Row ChangePoints(MediaQueryData mediaQuery, MemberManagementState state, FocusNode pointsFocusNode,BuildContext context,String id ) {

    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
  builder: (context, ste) {
    return SizedBox(
                          height: 59,
                          width: mediaQuery.size.width * 0.6,
                          child: GestureDetector(
                            onTap: () {
                              if (!ste.IsActive){
                              pointsFocusNode.requestFocus();
                              context.read<ChangeSboolsCubit>().changeActive(true);}
                              else{
                                pointsFocusNode.unfocus();
                                context.read<ChangeSboolsCubit>().changeActive(false);
                              }
                            },
                            child: TextField(
                              enabled:ste.IsActive ,
                              focusNode: pointsFocusNode,
                              style: PoppinsRegular(19, textColorBlack),
                             keyboardType: TextInputType.number,
                             keyboardAppearance: Brightness.dark,
                             textAlign: TextAlign.center,
                             onSubmitted: (valu) {
                               FunctionMember.savePoints(id,state.clone,context);

                               // context.read<MemberManagementBloc>().add(UpdatePointsEvent(int.parse(valu)));
                             },


                             controller: TextEditingController(text: state.clone.toInt().toString()),

                              decoration: InputDecoration(
                             prefix: InkWell(onTap: (){
                                context.read<MemberManagementBloc>().add(RemovePoints());
                             }, child: Icon(Icons.remove)),
                                  suffix: InkWell(onTap: (){

                                    context.read<MemberManagementBloc>().add(AddPoints());

                                  }, child: Icon(Icons.add)),
                            border: InputBorder.none //none

                                  ),
                            ),
                          ),
                        );
  },
),
                        InkWell(onTap:(){

                          FunctionMember.savePoints(id,state.clone,context);
                        } , child: Container(

                         height: 50,
                          decoration: BoxDecoration(
                            color: SecondaryColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text("Save", style: PoppinsRegular(18, Colors.white),)),
                          ),
                        ))
                      ],
                    );
  }

  static SizedBox CotisationField(MediaQueryData mediaQuery, MemberManagementState state,String text,int index,Function(bool?) onChanged) {
    return SizedBox(
                      width: mediaQuery.size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: textColor, width: 2)),
                          title: Text(text, style: PoppinsSemiBold(
                              16, textColorBlack, TextDecoration.none)),

                          subtitle: Row(
                            children: [
                              Text(
                                  FunctionMember.CheckBoolAtIndex(state.cotisation, index)?"Paid":"Not Paid", style: PoppinsRegular(20,
                                FunctionMember.CheckBoolAtIndex(state.cotisation, index)?Colors.green:Colors.red
                                  ,)),
                             Checkbox(
                               activeColor: PrimaryColor,


                               value:  FunctionMember.CheckBoolAtIndex(state.cotisation, index), onChanged: (value)=>onChanged(value),)
                            ],
                          ),

                        ),
                      ),
                    );
  }

  static Widget  AdminChangeSheet(BuildContext context,Member member) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          ProfileComponents.buildFutureBuilder(
              ListTileChangement(context, member,"Change To Admin ",(){FunctionMember.ChangeRole(member.id, MemberType. admin, context); })
              ,false, member.id, (p0) => FunctionMember.isReAdmin(member)),
          ProfileComponents.buildFutureBuilder(
              ListTileChangement(context, member,"Change To Member ",(){ FunctionMember.ChangeRole(member.id, MemberType. member, context);})
              ,false, member.id, (p0) => FunctionMember.isMember(member)),
          ProfileComponents.buildFutureBuilder(
              ListTileChangement(context, member,"Change To Super Admin ",(){ FunctionMember.ChangeRole(member.id, MemberType. superAdmin, context);})
              ,false, member.id, (p0) => FunctionMember.isSuperAdmin(member)),
        ]
      )
    );


  }

  static Padding ListTileChangement(BuildContext context, Member member,String text,Function() ontap ) {
    return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            onTap: (){
              ontap();

            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: textColor, width: 2)),
            title: Text(text, style: PoppinsSemiBold(
                16, textColorBlack, TextDecoration.none))
          )
        );
  }


}