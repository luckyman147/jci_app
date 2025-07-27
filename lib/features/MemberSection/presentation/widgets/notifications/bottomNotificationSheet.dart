import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Notification.dart';

import '../../../global-pres.dart';
import '../../bloc/Notifications/notification_bloc.dart';

class NotificationBottomSheet  {

  static showDeleteSheet(BuildContext context ,NotificationUser notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You want to Delete this Notification?',
              style: PoppinsSemiBold(15.sp, ColorsApp.textColorBlack, TextDecoration.none),
            ),
            SizedBox(height: 16),
            Text('Are you sure you want to delete this notification?',style: PoppinsRegular(13.sp, Colors.red),),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: ColorsApp.ThirdColor
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Cancel',style: PoppinsRegular(16, ColorsApp.textColorBlack),),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Delete',style: PoppinsRegular(16.sp, ColorsApp.textColorWhite),),
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<NotificationBloc>().add(
                      DeleteNotificationEvent(
                        notificationUser: notification.notificationId,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}