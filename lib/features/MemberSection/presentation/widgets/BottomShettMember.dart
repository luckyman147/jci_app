
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/MemberRepo.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
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
        return SizedBox(
            height: mediaQuery.size.height * 0.5,
            child: SingleChildScrollView(child: AdminChangeSheet(context,member)));
      },
    );
  }

  static BlocBuilder<ChangeSboolsCubit, ChangeSboolsState> PointsCotisationSheet(MediaQueryData mediaQuery, FocusNode pointsFocusNode, Member member) {
    return BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
builder: (context, state) {

  return AnimatedContainer(
    height:state.IsActive ? MediaQuery.of(context).size.height*.6 : 250,

        width: double.infinity,
        duration: const Duration(milliseconds: 300),
        child: BlocBuilder<MemberManagementBloc, MemberManagementState>(
          builder: (context, state) {

            return Column(
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: textColor, width: 2)),
                   title: SingleChildScrollView(
                       scrollDirection: Axis.horizontal,
                       child: ChangePoints(mediaQuery, state,  pointsFocusNode,context,member.id)),

                  ),
                ),Row(
                  children: [
                    CotisationField(mediaQuery, state,"1${"st".tr(context)} ${"Cotisation".tr(context)}",0,(valu){
                      FunctionMember.UpdateCotisationAction(member.id, 0, valu!,context);

                    },context),
                    state.cotisation.length>1?
                    CotisationField(mediaQuery, state,"2${"nd".tr(context)} ${"Cotisation".tr(context)}",1,(valu){
                      FunctionMember.UpdateCotisationAction(member.id, 1, valu!,context);

                    },context):IconButton.outlined(onPressed: (){
                      context.read<MemberManagementBloc>().add(const AddCotisation());
                    }, icon: const Icon(Icons.add)),
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
                          width: mediaQuery.size.width * 0.5,
                          child: Row(
                            children: [
                              InkWell(
                                onTap:  () {
                                  context.read<MemberManagementBloc>().add(const RemovePoints());
                                },
                                child:const  Icon(Icons.remove, color:  Colors.black ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    state.clone.toInt().toString(),
                                    style: PoppinsRegular(16, Colors.black
                                    )),
                                ),
                              ),
                              InkWell(
                                onTap:  () {
                                  context.read<MemberManagementBloc>().add(const AddPoints());
                                },
                                child:const  Icon(Icons.add, color:Colors.black ),
                              ),
                            ],
                          ),
                        );
  },
),
                  const       SizedBox(width: 7,),
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
                            child: Center(child: Text("Save".tr(context), style: PoppinsRegular(18, Colors.white),)),
                          ),
                        ))
                      ],
                    );
  }

  static SizedBox CotisationField(MediaQueryData mediaQuery, MemberManagementState state,String text,int index,Function(bool?) onChanged,BuildContext context) {
    return SizedBox(
                      width: mediaQuery.size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side:const  BorderSide(color: textColor, width: 2)),
                          title: Text(text, style: PoppinsSemiBold(
                              MediaQuery.devicePixelRatioOf(context)*5.5, textColorBlack, TextDecoration.none)),

                          subtitle: Row(
                            children: [
                              Text(
                                  FunctionMember.CheckBoolAtIndex(state.cotisation, index)?"Paid".tr(context):"Not Paid".tr(context), style: PoppinsRegular(MediaQuery.devicePixelRatioOf(context)*5,
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

      width: double.infinity,
      child: Column(
        children: <Widget>[
          ProfileComponents.buildFutureBuilder(
              ListTileChangement(context, member,"${"Change To".tr(context)} Admin ",(){FunctionMember.ChangeRole(member.id, MemberType. admin, context); })
              ,false, member.id, (p0) => FunctionMember.isReAdmin(member)),
          ProfileComponents.buildFutureBuilder(
              ListTileChangement(context, member,"${"Change To".tr(context)} ${"Member".tr(context)} ",(){ FunctionMember.ChangeRole(member.id, MemberType. member, context);})
              ,false, member.id, (p0) => FunctionMember.isMember(member)),
          ProfileComponents.buildFutureBuilder(
              ListTileChangement(context, member,"${"Change To".tr(context)} Super Admin ",(){ FunctionMember.ChangeRole(member.id, MemberType. superAdmin, context);})
              ,false, member.id, (p0) => FunctionMember.isSuperAdmin(member)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    ),
         ),
              onPressed: (){
                context.read<MemberManagementBloc>().add(deleteMemberEvent(id: member.id));
              }, child: Text("${"Delete".tr(context)} ${"Member".tr(context)}", style: PoppinsSemiBold(16, Colors.white, TextDecoration.none)))

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
                side: const BorderSide(color: textColor, width: 2)),
            title: Text(text, style: PoppinsSemiBold(
                16, textColorBlack, TextDecoration.none))
          )
        );
  }


}