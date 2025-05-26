import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';
import '../../../../core/app_theme.dart';
import '../../domain/entity/ActionDetails.dart';


class CibleSelector extends StatelessWidget {
  final List<CibleType> cibleOptions;
  final bool isError;


  const CibleSelector({
    Key? key,
    required this.cibleOptions, required this.isError,

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
                      "Choose a target role".tr(context),
                      style: PoppinsSemiBold(
                          24.sp, ColorsApp.textColorBlack, TextDecoration.none),
                    ),

                    ...cibleOptions.map((cible) {
                      return ListTile(
                          title: AutoSizeText(cible.name.doublesWords.tr(context), style: PoppinsRegular(
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

                                }, child: AutoSizeText(state.cibles.contains(cible)?"Selected".tr(context):"Select".tr(context),
                            style: PoppinsRegular(14.sp,state.cibles.contains(cible)?ColorsApp.textColorWhite:ColorsApp.textColorBlack), ),


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
       child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           BlocBuilder<ObjectifFormCubit, ObjectifFormState>(
            builder: (context, state) {
              return InkWell(
                onTap: () => _showCibleBottomSheet(context),
                child: Container(
                  height: 60.h,
                  width: double.infinity,
                  padding: paddingSemetricVerticalHorizontal(),
                  decoration: BoxDecoration(
                    border:  Border.all(color:!isError?ColorsApp.textColorBlack:Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                  state.cibles.isEmpty?Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      "Choose a target role".tr(context),
                      style: PoppinsRegular(19.sp, ColorsApp.ThirdColor),
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
                              state.cibles[index].name.doublesWords.tr(context),
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
           isError?Padding(
             padding:paddingSemetricVerticalHorizontal(),
             child: Text("Select a target role",style: PoppinsRegular(17.sp, Colors.red),),
           ):Container()
         ],
       ),
     );
  }
}
