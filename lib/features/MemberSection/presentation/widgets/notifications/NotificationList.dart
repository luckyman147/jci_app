
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Home/Activity_Global.dart';
import '../../bloc/Notifications/notification_bloc.dart';
import 'NotificationTile.dart';

class NotificationList extends StatelessWidget {
  const NotificationList ({
    super.key,
    required this.controller,
    required this.state,

  });
  final NotificationState state;
  final ScrollController controller;


  @override
  Widget build(BuildContext context) {
    List<ValueNotifier<bool>> expandStates =
    List.generate(state.hasReachedMax?state.notifications.length:state.notifications.length+1, (_) => ValueNotifier<bool>(false));

    return ListView.separated(
      controller: controller,
      shrinkWrap: true,
      itemCount:state.hasReachedMax?state.notifications.length:state.notifications.length+1,

      itemBuilder: (context, index) {
        if (index<state.notifications.length){

          final item = state.notifications[index];
          return NotificationTile(notification: item, isExpanded: expandStates[index],);}
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
              style:
              ElevatedButton.styleFrom(
                side: BorderSide(color: ColorsApp.textColorBlack),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),

                ),
              )
              ,
              onPressed: (){
                context.read<NotificationBloc>().add(LoadMoreNotificationsEvent(lastDocument: state.lastDocument));

              }, child: Text("Load More".tr(context),style: PoppinsNorml(18.sp, ColorsApp.textColorBlack),)),
        );

      }, separatorBuilder: (BuildContext context, int index) {
      return const SizedBox(height: 11,);
    },
    );
  }
}