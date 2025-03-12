import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/Member.dart';
import 'package:jci_app/core/strings/objectifsIcon.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/MemberSection/domain/entity/UserObjectifInfos.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';

import '../../../../../core/app_theme.dart';
import '../../../domain/entity/ActionDetails.dart';


class CibleSelector extends StatelessWidget {
  final List<CibleType> cibleOptions;


  const CibleSelector({
    Key? key,
    required this.cibleOptions,

  }) : super(key: key);

  void _showCibleBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: BlocBuilder<ObjectifFormCubit, ObjectifFormState>(
              builder: (context, state) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      "Choose a target role",
                      style: PoppinsSemiBold(
                          24.sp, ColorsApp.textColorBlack, TextDecoration.none),
                    ),

                    ...cibleOptions.map((cible) {
                      return ListTile(
                          title: AutoSizeText(cible.name.doublesWords, style: PoppinsRegular(
                              17.sp, ColorsApp.textColorBlack),),
                          // Assuming Dart >= 2.17 (name getter)
                          trailing: SizedBox(
                            width: 130.w,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: state.cibles.contains(cible)?ColorsApp.PrimaryColor:ColorsApp.textColorWhite,
                                                side: const BorderSide(color: ColorsApp.textColorBlack, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),

                              onPressed: (){
                                if (!state.cibles.contains(cible)){
                                  context.read<ObjectifFormCubit>().setCibles(cible);
                                      }
                                else{
                                  context.read<ObjectifFormCubit>().removeCible(cible);}

                                }, child: AutoSizeText(state.cibles.contains(cible)?"Selected":"Select",
                            style: PoppinsRegular(17.sp,state.cibles.contains(cible)?ColorsApp.textColorWhite:ColorsApp.textColorBlack), ),


                            ),
                          )

                      );
                    }).toList(),

                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: BlocBuilder<ObjectifFormCubit, ObjectifFormState>(
        builder: (context, state) {
          return InkWell(
            onTap: () => _showCibleBottomSheet(context),
            child: Container(
              height: 60.h,
              width: double.infinity,
              padding: paddingSemetricVerticalHorizontal(),
              decoration: BoxDecoration(
                border: Border.all(color: ColorsApp.textColorBlack, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
              state.cibles.isEmpty?Center(
                child: AutoSizeText(
                  "Select a target role",
                  style: PoppinsRegular(20.sp, ColorsApp.ThirdColor),
                ),
              ):

              SizedBox(
                height: 50.h,
                width: MediaQuery.of(context).size.width/1.5,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: paddingSemetricHorizontal(h: 4),
                      child: Center(
                        child: AutoSizeText(
                          state.cibles[index].name,
                          style: PoppinsSemiBold(18.sp, ColorsApp.textColorBlack,TextDecoration.none),
                        ),
                      ),
                    );
                  },
                  itemCount: state.cibles.length,

                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          );
        },
           ),
     );
  }
}
