import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/app.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/notifications/NotificationList.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/strings/Images.string.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../global-pres.dart';
import '../../bloc/Notifications/notification_bloc.dart';
import 'No_NotificationWidget.dart';
import 'ShimmerNotification.dart';

class Notificationimplementations extends StatelessWidget {
  const Notificationimplementations({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: PrimaryColor,
        onRefresh: () {
      context.read<NotificationBloc>().add(LoadNotificationsEvent(isRefreshed: true, lastDocument: null));
      return Future.delayed(Duration(seconds: 1));


      }, child: BlocConsumer<NotificationBloc,NotificationState>
      (builder: (context,state){
       return state.status.when(
            initial: ()=> const ShimmernotificationList(),
            loading: ()=>const ShimmernotificationList(),
            loaded: (){

              return NotificationList(controller: controller, state: state);
            },
            error: ()=>Center(child: Text('failed to fetch Notifications',style:PoppinsNorml(18.sp, ColorsApp.textColorBlack) ,),),
            empty: () {

              return No_notiifcationWidget();
                          });

    }, listener: (BuildContext context, NotificationState state) {
        if (state.status==NotificationsStatus.Updated){
          context.read<MembersBloc>().add(GetUserProfileEvent(true));
        }


    },


    ),);
  }
}
