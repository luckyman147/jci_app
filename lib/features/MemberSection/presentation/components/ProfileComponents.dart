import 'dart:convert';
import 'dart:developer';
import 'dart:io';


import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/DataSources/RemotePermissionsDataSources.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/Compoenents.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/ErrorDisplayMessage.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/functions/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/EventSelection.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamWidget.dart';

import '../../../../core/PrimitiveUser/User.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../Home/domain/entities/Activity.dart';
import '../../../Home/domain/enums/ActionImage.dart';
import '../../../Home/presentation/widgets/Members/component/ProfileImage.dart';
import '../../../Teams/data/models/TeamModel.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../Teams/presentation/widgets/DetailTeamComponents.dart';
import '../../../../core/MemberModel.dart';
import '../../../../core/Member.dart';
import '../../domain/usecases/MemberUseCases.dart';
import '../constants/decoration.dart';
import '../pages/user/memberProfilPage.dart';
import '../widgets/achivements/AchivementsWidget.dart';
import '../widgets/member/BottomShettMember.dart';
import '../widgets/member/DescriptionWidget.dart';
import '../widgets/member/MemberImpl.dart';
import '../widgets/utils/ShimmerEffects.dart';
import 'AboutMemberComponent.dart';
import 'buttonsComponents.dart';

class ProfileComponents {

  static bool isInitial(StatesBool value) => value == StatesBool.Initial;

  static bool isDes(StatesBool value) => value == StatesBool.Description;

  static bool iTeams(StatesBool value) => value == StatesBool.Teams;

  static bool iActivities(StatesBool value) => value == StatesBool.Activities;

  static bool iMembers(StatesBool value) => value == StatesBool.Members;

  static bool isPoints(StatesBool value) => value == StatesBool.Points;

  static bool isObjectif(StatesBool value) => value == StatesBool.Objectifs;

  static bool isJCI(StatesBool value) => value == StatesBool.JCI;


  /// member s info component
  static Widget BuildInfoRow(IconData icon, String text) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Center(
        child: Container(
          decoration: boxDecoration,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, color: textColorBlack,),
                Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Text(
                    text, style: PoppinsRegular(17, textColorBlack,),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

class StaticsContainer extends StatelessWidget {
  final String number; // Number to display
  final String text;   // Text to display
final Color color;
final Function() onTap;
  // Color of the container
  const StaticsContainer({
    Key? key,
    required this.number,
    required this.text, required this.color, required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: InkWell(
        onTap: onTap,

        child: Container(
height: 100.h,
          width: MediaQuery.of(context).size.width/3.2,
          decoration: AboutMemberComponent.profilbox().copyWith(
            color: color,border: Border.all(color: ColorsApp.textColorBlack,width: 2),

          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Minimize the size of the Column
                children: [
                  AutoSizeText(
                    text, // Display the text
                    style: PoppinsSemiBold(15.sp, ColorsApp.textColorWhite,TextDecoration.none),
                  ),
                  SizedBox(height: 4), // Space between number and text
              AutoSizeText(

                    number, // Display the number
                    style: PoppinsSemiBold(20.sp, ColorsApp.textColorWhite, TextDecoration.none),
                  ),
                ],
              ),
            ),
          ),
        ).animate(
          effects: [const ScaleEffect(
            duration: Duration(milliseconds: 478)
          )]

        ),
      ),
    );
  }
}
