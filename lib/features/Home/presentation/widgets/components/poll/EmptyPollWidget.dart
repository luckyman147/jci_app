
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/presentation/widgets/Implementations/ActivtysImplementations.dart';

import '../../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/config/env/Constants.dart';
import '../../../../../../core/strings/Images.string.dart';
import '../../../../../MemberSection/global-pres.dart';
import '../../../bloc/Activity/activity_cubit.dart';
import '../../Fields/AddPoll.dart';

class EmptyPollWidget extends StatelessWidget {
  const EmptyPollWidget({
    super.key,
    required this.activityId,
    required this.eventType,
  });

  final String activityId;
  final activity eventType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            children: [
              Image.asset(images.hello, height: 100.h,),
              Text('No Polls Available'.tr(context),style: PoppinsRegular(16.sp, ColorsApp.textColorBlack),),
              AsyncComponents.buildFutureBuilder( AddButtonWi (

                  ColorsApp.PrimaryColor,
                  ColorsApp.textColor,
                  Icons.add,(){
                showDialog(
                  context: context,
                  builder: (ctx) => AddPollDialog(ActivityId: activityId),
                );
              }

              ),
                  PermissionType.canCreate,

                  eventType==activity.Events?   Constants.MANAGE_EVENTS
                      :eventType==activity.Meetings? Constants.MANAGE_MEETINGS
                      :Constants.MANAGE_TRAININGS
              ),
            ],
          ),
        ),
      ),
    );
  }
}
