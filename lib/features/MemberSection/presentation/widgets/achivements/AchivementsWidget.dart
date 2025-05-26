import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/app.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/functions/PermissionFunctions.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/objectifsIcon.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/objectif/ObjectifFormPage.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../core/config/env/Constants.dart';
import '../../../domain/entity/ActionDetails.dart';
import 'BottomSheetFilterBy.dart';

class AchievementWidget extends StatelessWidget {
  final UserObjectif userObjectif;
  final Objectif objectif;
  final String memberid;
  final ValueNotifier<bool> isExpanded;

  const AchievementWidget({
    Key? key,
    required this.userObjectif,
    required this.objectif,
    required this.isExpanded,
    required this.memberid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricHorizontal(),
      child: BlocBuilder<PermissionsBloc, PermissionsState>(
        builder: (context, state) {
          return ValueListenableBuilder<bool>(
            valueListenable: isExpanded,
            builder: (context, isTrue, child) {
              return AnimatedContainer(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border(
                    left: BorderSide(
                      color:
                      userObjectif.isCompleted?Colors.green:

                      ObjectifDifficultyColor().objectifDifficultyColor[objectif.difficulty] ?? ColorsApp.textColorWhite,
                      width: 6,
                    ),
                  ),
                ),
                duration: const Duration(milliseconds: 300),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onLongPress: () {
                        if (!_isCompletedAndHasPermissions(state)) return;

                        BottomSheets.ShowUpdateDeleteObjectifSheet(context, objectif, memberid);
                      },
                      onTap: () {
                        isExpanded.value = !isExpanded.value;
                      },
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      trailing: _buildTrailing(),
                      leading: Icon(
                        userObjectif.isCompleted ? Icons.check_circle : ObjectifIcons().objectifIcons[objectif.feature]!.icon,
                        color: userObjectif.isCompleted ? Colors.green : ObjectifDifficultyColor().objectifDifficultyColor[objectif.difficulty] ?? textColor,
                        size: 28,
                      ),
                      title: _buildTitle(context),
                      subtitle: _buildProgressBar(context),
                    ),
                    if (isTrue) _buildExpandedDetails(  context),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool _isCompletedAndHasPermissions(PermissionsState state) {
    return !userObjectif.isCompleted &&
        PermissionsFunctions.HasPermission(state, Constants.MANAGE_OBJECTIFS, PermissionType.canUpdate) &&
        PermissionsFunctions.HasPermission(state, Constants.MANAGE_OBJECTIFS, PermissionType.canDelete);
  }

  Widget _buildTrailing() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ( userObjectif.isCompleted?Colors.green: ColorsApp.PrimaryColor).withOpacity(.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: paddingSemetricVerticalHorizontal(),
              child: AutoSizeText("${objectif.points} pts", style: PoppinsRegular(14.sp,userObjectif.isCompleted?Colors.green: ColorsApp.PrimaryColor)),
            ),
          ).animate(
            effects: [const FadeEffect(duration: Duration(milliseconds: 500))],
          ),
          if (objectif.target != null && objectif.target != 0)
            Text("${userObjectif.currentProgress}/${objectif.target}", style: PoppinsRegular(17.sp, ColorsApp.ThirdColor))
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          children: [
            Icon(GroupObjectifIcons.getIcon(objectif.groupObjectif), color: GroupObjectifIcons.getcolor(objectif.groupObjectif), size: 20),
            SizedBox(width: 10.sp),
            AutoSizeText(
              objectif.groupObjectif.name.doublesWords.tr(context),
              style: PoppinsLight(15.sp, GroupObjectifIcons.getcolor(objectif.groupObjectif)),
            ),
          ],
        ),
        Text(
          "${objectif.objectifActionType.name.doublesWords.tr(context)} ${objectif.target == 0 ? "" : objectif.target} ${objectif.feature.name.doublesWords.tr(context)}",
          style: PoppinsSemiBold(17, userObjectif.isCompleted ? PrimaryColor : ColorsApp.textColorBlack, TextDecoration.none),
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SimpleAnimationProgressBar(
          ratio: userObjectif.isCompleted
              ? 2
              : (objectif.target == null  || objectif.target == 0)
              ? 0.01
              : (userObjectif.currentProgress! / objectif.target!).clamp(0.0, 2.0),
          backgroundColor: ColorsApp.BackWidgetColor,
          direction: Axis.horizontal,
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(seconds: 3),


          width: MediaQuery.of(context).size.width/4, height: 30.sp,
          foregrondColor:userObjectif.isCompleted?Colors.green: ColorsApp.PrimaryColor,
        )
      ),
    );
  }

  Widget _buildExpandedDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Wrap(
            spacing: 10,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              if (objectif.difficulty != null) _lessOpacityContainer(objectif.difficulty!.name, ObjectifDifficultyColor().objectifDifficultyColor[objectif.difficulty]!, "Difficulty",context),
              if (objectif.privacy != null) _lessOpacityContainer(objectif.privacy!.name, objectif.privacy == PrivacyType.Public ? Colors.green : Colors.red, "Privacy",context),
            ],
          ),
        ),
        Wrap(
          children: [
            Padding(
              padding: paddingSemetricVerticalHorizontal(h: 15.sp, v: 1.sp),
              child: Icon(Icons.supervised_user_circle_outlined, color: ColorsApp.SecondaryColor, size: 30),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 8.sp),
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                verticalDirection: VerticalDirection.up,
                spacing: 10,
                runSpacing: 5,
                runAlignment: WrapAlignment.start,
                children: objectif.cible.map((e) => _buildCibleContainer(e.name.doublesWords.tr(context))).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCibleContainer(String name) {
    return Container(
      decoration: BoxDecoration(color: ColorsApp.BackWidgetColor, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: paddingSemetricVerticalHorizontal(),
        child: Text(name.doublesWords, style: PoppinsSemiBold(14.sp, ColorsApp.textColorBlack, TextDecoration.none)),
      ),
    );
  }

  Container _lessOpacityContainer(String name, Color color, String type,BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      margin: EdgeInsets.only(bottom: 8.sp),
      padding: EdgeInsets.all(8.sp),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: paddingSemetricHorizontal(),
        child: Column(
          children: [
            Center(child: Text(type, style: PoppinsNorml(14.sp, color))),
            Center(child: Text(name.doublesWords, style: PoppinsRegular(14.sp, color))),
          ],
        ),
      ),
    );
  }
}
