import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/MemberSection/data/model/NotificationUserModel.dart';
import 'package:jci_app/features/MemberSection/domain/dto/NotificationPagintion.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Notification.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../auth/AuthWidgetGlobal.dart';
import '../../../domain/usecases/NotificationUseCases.dart';

part 'notification_event.dart';
part 'notification_state.dart';
const throttleDuration = Duration(milliseconds: 600);
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  
  final GetAllNotificationByPaginationUsesCase getAllNotificationByPaginationUsesCase;
  final CreateNotificationUsesCase createNotificationUsesCase;
  final DeleteNotificationUsesCase deleteNotificationUsesCase;
  final UpdateSeenToTrueUsesCases updateSeenToTrueUsesCases;
  NotificationBloc(this.getAllNotificationByPaginationUsesCase, this.createNotificationUsesCase, this.deleteNotificationUsesCase, this.updateSeenToTrueUsesCases) : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<UpdateNotificationSeenEvent>(_updateNotifications);
    on<CreateNotificationEvent>(_CreateObjetifs);
    on<DeleteNotificationEvent>(_deleteNotifications);
    on<LoadMoreNotificationsEvent>(_loadMoreNotificationss);
    on<LoadNotificationsEvent>(_loadNotificationss);
  }

  _CreateObjetifs(CreateNotificationEvent event,Emitter<NotificationState>emit) async {

    try {
      emit(state.copyWith(status: NotificationsStatus.Loaded));
      final request=    await createNotificationUsesCase.call(event.notificationUser);
      emit(EitherNotificationssOrSucces(request, (r) {

        return      state.copyWith(status: NotificationsStatus.Created);
      }));
    } catch (e) {
      Logger().e(e);
      emit(state.copyWith(status: NotificationsStatus.Error));
    }}
  ///Edit objetif
  _updateNotifications(UpdateNotificationSeenEvent event,Emitter <NotificationState>emit) async {


    try {
      final request = await updateSeenToTrueUsesCases.call(event.notificationUser);
      emit(EitherNotificationssOrSucces(request, (r) {
     return   state.copyWith(
          notifications: state.notifications.map((notification) {
            if (notification.notificationId == event.notificationUser) {
              // Update the `seen` property of the matching notification
              return NotificationUserModel.fromFactory(notification).copyWith(seen: true);
            }
            return notification; // Return the notification unchanged if it doesn't match
          }).toList(),
          status: NotificationsStatus.Updated,
        );      }));
    } catch (e) {
      Logger().e(e);
      emit(state.copyWith(status: NotificationsStatus.Error));
    }
  }

  ///Delete Notifications
  _deleteNotifications(DeleteNotificationEvent event,Emitter<NotificationState>emit) async {
    emit(state.copyWith(status: NotificationsStatus.Loading,));

    try {
      final request = await deleteNotificationUsesCase.call(event.notificationUser);
      emit(EitherNotificationssOrSucces<Unit>(request, (r) {
        //delete the Notifications from the list
        state.notifications.removeWhere((element) => element.notificationId== event.notificationUser);
        //update map
        return state.copyWith(status: NotificationsStatus.Deleted,notifications: state.notifications,);
      }));
    } catch (e) {
      Logger().e(e);
      emit(state.copyWith(status: NotificationsStatus.Error));
    }
  }



  ///Load Notificationss event

  _loadNotificationss(LoadNotificationsEvent event,Emitter<NotificationState>emit) async {
    emit( state.copyWith(status: NotificationsStatus.Loading));
    if (state.notifications.isNotEmpty&&!event.isRefreshed){

      emit(state.copyWith(status: NotificationsStatus.Loaded));
    }
    if (event.isRefreshed){
      emit(state.copyWith(hasReachedMax: false));
    }
    try {
      final Notificationss = await getAllNotificationByPaginationUsesCase.call(
          NotificationPaginationRequest(

            lastDocument: null,

          )

      );
      emit(EitherNotificationssOrSucces(Notificationss,(not) {
        if (not.notifications.isEmpty) {
          return state.copyWith(hasReachedMax: true,status: NotificationsStatus.Empty);
        }

        else {
          return state.copyWith(
              notifications: not.notifications,
              status: NotificationsStatus.Loaded,
              lastDocument: not.lastDocument

          );}
      } ));
    } catch (e) {
      Logger().w(e);
      emit( state.copyWith(status: NotificationsStatus.Error));
    }
  }

   _loadMoreNotificationss(LoadMoreNotificationsEvent event,Emitter<NotificationState>emit) async {
    if (state.hasReachedMax || state.status == NotificationsStatus.Loading) return;

    try {
      final Notificationss = await getAllNotificationByPaginationUsesCase.call(
          NotificationPaginationRequest(

            lastDocument: event.lastDocument,

          )
      );



      emit( EitherNotificationssOrSucces<NotificationPaginationResponse>(Notificationss, (objs){

        if (objs.notifications.isEmpty) {
          return state.copyWith(hasReachedMax: true);
        }

        else {
          return  state.copyWith(
              notifications: [...state.notifications, ...objs.notifications],
              status: NotificationsStatus.Loaded,
              lastDocument:objs.lastDocument
          );
        }


      }));
    } catch (_) {
      emit( state.copyWith(status: NotificationsStatus.Error));
    }
  }
  NotificationState EitherNotificationssOrSucces<T>(Either<Failure,T> request,Function(T) function){
    return request.fold(
          (l) => state.copyWith(status: NotificationsStatus.Error),
          (r) => function(r),
    );
  }

  
  
}
