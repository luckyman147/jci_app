import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/MemberSection/data/datasources/NotificationsRemoteDataSources.dart';
import 'package:jci_app/features/MemberSection/data/model/NotificationUserModel.dart';
import 'package:jci_app/features/MemberSection/domain/dto/NotificationPagintion.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Notification.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/NotificationRepo.dart';

class NotificationRepoImpl extends NotificationsRepo{
  final NotificationRemoteDataSources notificationRemoteDataSources;
  final Handler<Unit> unitHandler;
  final Handler<NotificationPaginationResponse> responseHandler;

  NotificationRepoImpl({required this.notificationRemoteDataSources, required this.unitHandler, required this.responseHandler});

  @override
  Future<Either<Failure, Unit>> createNotification(NotificationUser notification)async {

    return await unitHandler.handle(onCall: ()async{
     await  notificationRemoteDataSources.createNotification(NotificationUserModel.fromFactory(notification));
      return unit;



    },


        onError: (e){
      if (e is Exception) {
        throw e;
      }
      throw e;

        });

  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(String notificationId)async {

    return await unitHandler.handle(onCall: ()async{
      await  notificationRemoteDataSources.deleteNotification(notificationId);
      return unit;
    },
        onError: (e){
          if (e is Exception) {
            throw e;
          }
          throw e;

        });
  }

  @override
  Future<Either<Failure, NotificationPaginationResponse>> getNotificationsByPagination(NotificationPaginationRequest request)async {

    return await responseHandler.handle(onCall: ()async{
  return    await  notificationRemoteDataSources.getNotificationsByPagination(request);

    },


        onError: (e){
          if (e is Exception) {
            throw e;
          }
          throw e;

        });

  }

  @override
  Future<Either<Failure, Unit>> updateSeenToTrue(String notificationId) async{

    return await unitHandler.handle(onCall: ()async{
      await  notificationRemoteDataSources.updateSeenToTrue(notificationId);
      return unit;



    },

        onError: (e){
          if (e is Exception) {
            throw e;
          }
          throw e;

        });
  }
}