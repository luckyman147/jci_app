import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/components/buttonsComponents.dart';

import '../../../domain/entity/Objectif.dart';
import '../../bloc/objectifs/objectif_bloc.dart';
import '../../components/ObjectifField.dart';
import '../../pages/objectif/ObjectifFormPage.dart';
import 'FilterWiget.dart';

class BottomSheets {
  static void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full height scrolling
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FilterWidget();
      },
    );
  }



    static  ShowUpdateDeleteObjectifSheet(BuildContext context,Objectif objectif,String id){
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        useSafeArea: true,
 // Allows the sheet to adapt to content
        builder: (BuildContext context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonsMemberComponents.buttonWithicon("Update".tr(context), (){

                context.read<ObjectifFormCubit>().SetObjectifDetails(objectif);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Objectifformpage(obj: objectif, MemberId: id, event: ObjectiveEvent.Edit,))

                );



              }, Icons.edit, context,ObjectiveEvent.Edit),
              ButtonsMemberComponents.buttonWithicon("Delete".tr(context), (){
                context.read<ObjectifBloc>().add(DeleteObjectifEvent(objectifId: objectif.id));

              }, Icons.delete, context,ObjectiveEvent.Delete),

            ],


          );
        },
      );
  }

}
