import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Notification.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Notifications/notification_bloc.dart';

import '../../../../Home/Activity_Global.dart';
import '../../../global-pres.dart';
import 'NotificationImplementations.dart';
import 'NotificationTile.dart';

class NotificationsDrawer extends StatefulWidget {


  const NotificationsDrawer({Key? key, }) : super(key: key);

  @override
  State<NotificationsDrawer> createState() => _NotificationsDrawerState();
}

class _NotificationsDrawerState extends State<NotificationsDrawer> {
  final _scrollController = ScrollController();
  late NotificationBloc notificationBloc;
  @override
  void initState() {
    super.initState();
    notificationBloc= BlocProvider.of<NotificationBloc>(context);

    notificationBloc.add(LoadNotificationsEvent(lastDocument: null, isRefreshed: false));
    _scrollController.addListener(_onScroll);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void _onScroll() {
    if (_isBottom) notificationBloc.add(LoadMoreNotificationsEvent( lastDocument: notificationBloc.state.lastDocument,));
  }
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              children: [
                BackButton(
                  onPressed: (){
                     Navigator.pop(context);
                  },

                ),
                 Expanded(
                  child: Center(
                    child: Text(
                      'Notifications',
                      style: PoppinsSemiBold(20.sp, ColorsApp.textColorBlack, TextDecoration.none)
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balance the row with empty space
              ],
            ),
          ),
          Expanded(
            child: Notificationimplementations(controller: _scrollController),
          ),
        ],
      ),
    );
  }
}

