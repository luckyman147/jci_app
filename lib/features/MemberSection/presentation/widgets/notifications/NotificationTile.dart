import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/app.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/notifications/bottomNotificationSheet.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../../core/app_theme.dart';
import '../../../domain/entity/Notification.dart';
import '../../../global-pres.dart';
import '../../bloc/Notifications/notification_bloc.dart';
class NotificationTile extends StatelessWidget {
  final NotificationUser notification;
  final ValueNotifier<bool> isExpanded;
  final Color seenColor;
  final Color unseenColor;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.isExpanded,
    this.seenColor = Colors.green,
    this.unseenColor = Colors.red,
  }) : super(key: key);
  bool get isNewNotification {
    final now = DateTime.now();
    final difference = now.difference(notification.createdAt);
    return difference.inHours < 24;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isExpanded,
      builder: (context, isExpandedValue, _) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _buildTile(context, isExpandedValue),
            if (isNewNotification) _buildNewBadge(context),
          ],
        );
      },
    );
  }

  Positioned _buildNewBadge(BuildContext context) {
    return Positioned(
      top: -5,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: SecondaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'NEW'.tr(context),
          style: PoppinsSemiBold(
            10.sp,
            ColorsApp.textColorWhite,TextDecoration.none
          ),
        ),
      ),
    );
  }


  Widget _buildTile(BuildContext context, bool isExpandedValue) {
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      duration: const Duration(milliseconds: 300),
      decoration: _buildBoxDecoration(),
      child: ListTile(
        onLongPress: () {
          NotificationBottomSheet.showDeleteSheet(context, notification);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: _buildTitle(),
        subtitle: _buildSubtitle(context, isExpandedValue),
        onTap: () => _handleTap(context),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Colors.grey.withOpacity(0.2),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Icon(
          notification.icon,
          color: notification.color,
          size: 20,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: AutoSizeText(
            notification.title,
            style: PoppinsRegular(
              15.sp,
              ColorsApp.textColorBlack,
            ),
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context, bool isExpandedValue) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBodyText(isExpandedValue),
          const SizedBox(height: 4),
          _buildFooterRow(context),
        ],
      ),
    );
  }

  Widget _buildBodyText(bool isExpandedValue) {
    return AutoSizeText(
      notification.body,
      style: PoppinsLight(
        14.sp,
        ColorsApp.textColorBlack,
      ),
      maxLines: isExpandedValue ? null : 1,
      overflow: isExpandedValue ? null : TextOverflow.ellipsis,
    );
  }

  Widget _buildFooterRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimeAgoText(),
        _buildStatusIndicator(),
      ],
    );
  }

  Widget _buildTimeAgoText() {
    return AutoSizeText(
      timeago.format(notification.createdAt),
      style: PoppinsLight(
        13.sp,
        ColorsApp.textColor,
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: paddingSemetricVerticalHorizontal(),
      decoration: BoxDecoration(
        color: notification.seen ? seenColor : unseenColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          notification.seen ? "Seen" : "Not Seen",
          style: PoppinsRegular(13.sp, Colors.white),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (!notification.seen) {
      context.read<NotificationBloc>().add(
          UpdateNotificationSeenEvent(
              notificationUser: notification.notificationId
          )
      );
    }
    isExpanded.value = !isExpanded.value;
  }
}