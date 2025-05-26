
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/strings/Images.string.dart';
import '../../../global-pres.dart';
import '../../bloc/Notifications/notification_bloc.dart';

class No_notiifcationWidget extends StatelessWidget {
  const No_notiifcationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(images.No_notification,scale: .5,),
          const SizedBox(height: 20),
          Text(
            'No Notification Yet'.tr(context),
            style: PoppinsSemiBold(17.sp, ColorsApp.textColorBlack, TextDecoration.none),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no notifications right now'.tr(context),
            style: PoppinsRegular(15.sp, ColorsApp.textColorBlack, ),
          ),
          const SizedBox(height: 4),
          Text(
            'Come Back Later'.tr(context),
            style: PoppinsRegular(15.sp, ColorsApp.textColorBlack,),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Add your refresh logic here
              context.read<NotificationBloc>().add(LoadNotificationsEvent(lastDocument: null, isRefreshed: true));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsApp.PrimaryColor, // Button color
              foregroundColor: Colors.white, // Text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13), // 13 radius
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: AutoSizeText(
              'Search Again'.tr(context),
              style: PoppinsSemiBold(15.sp, Colors.white, TextDecoration.none),
            ),
          ),
        ],
      ),
    );
  }
}
