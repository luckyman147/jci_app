
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/MemberRepo.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/components/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/functions/functionMember.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/PresWidgets.dart';

import '../../../../../core/Member.dart';

class BottomMemberSheet {

  static showBottomCotisationSheet(BuildContext context, Member member, ) {
    showModalBottomSheet(


      showDragHandle: true,
useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        final mediaQuery = MediaQuery.of(context);
        return PointsCotisationSheet(mediaQuery, member);
      },
    );
  }
static void  showFiltring(BuildContext context){
        showModalBottomSheet(context: context, builder: (context){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${"Sort".tr(context)} ${"By".tr(context)}:",style: PoppinsRegular( 20, textColorBlack),),
            const SizedBox(height: 10,),
            BuildSortMember(context,"Membership".tr(context),()=>null,true),
            BuildSortMember(context,"Points",()=>null,false),
            BuildSortMember(context,"Role",()=>null,false),
          ],
        ),
      );
    });
}

  static Padding BuildSortMember(BuildContext context,String sort,Function() onChanged,bool isSelected) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: ListTile(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: PrimaryColor)
        ),
        style: ListTileStyle.drawer,

        selected:isSelected,
        selectedTileColor: PrimaryColor,
        title: Text("${"By".tr(context)} $sort",style: PoppinsRegular( 18, isSelected?textColorWhite:textColorBlack),),
        onTap: (){
          onChanged();
          Navigator.pop(context);

          //context.read<MembersBloc>().add(GetMemberByNameEvent( name: ""));
        },

      ),
    );
  }

  static BlocBuilder<ChangeSboolsCubit, ChangeSboolsState> PointsCotisationSheet(MediaQueryData mediaQuery, Member member) {
    return BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
builder: (context, state) {

  return AnimatedContainer(


        width: double.infinity,
        duration: const Duration(milliseconds: 300),
        child: BlocBuilder<MemberManagementBloc, MemberManagementState>(
          builder: (context, state) {

            return Padding(
              padding:paddingSemetricVertical(),
              child: Row(
                 children: [
                   CotisationField(mediaQuery, state,"1${"st".tr(context)} ${"Cotisation".tr(context)}",0,(valu){
                     FunctionMember.UpdateCotisationAction(member.id!, 0, valu!,context);

                   },context),
                   state.cotisation.length>1?
                   CotisationField(mediaQuery, state,"2${"nd".tr(context)} ${"Cotisation".tr(context)}",1,(valu){
                     FunctionMember.UpdateCotisationAction(member.id!, 1, valu!,context);

                   },context):IconButton.outlined(onPressed: (){
                     context.read<MemberManagementBloc>().add(const AddCotisation());
                   }, icon: const Icon(Icons.add)),
                 ],
               ),
            );
          },
        ),
      );
},
);
  }

  static Row ReportsRow(MediaQueryData mediaQuery, BuildContext context, Member member) {
    return Row(
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
                                context.read<MemberManagementBloc>().add(SendMembershipReportEvent(id:member.id!)),
                    ),
                  ),
                  SizedBox(
                    width: mediaQuery.size.width * 0.5,
                    child: PresWidgets.ButtonActions(context, BoxDecoration(border: Border.all(
                      width: 2,
                      color:textColor

                    ),borderRadius: BorderRadius.circular(15
                    )), Icons.report, "Inactivity Report", () =>
                                context.read<MemberManagementBloc>().add(SendInactivityReportEvent(id:member.id!)),
                    ),
                  ),
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