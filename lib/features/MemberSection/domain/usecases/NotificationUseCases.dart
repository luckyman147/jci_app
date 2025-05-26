import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/MemberSection/domain/dto/NotificationPagintion.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/NotificationRepo.dart';

import '../entity/Notification.dart';

class GetAllNotificationByPaginationUsesCase extends UseCase<NotificationPaginationResponse,NotificationPaginationRequest>{
  final NotificationsRepo repo;

  GetAllNotificationByPaginationUsesCase({required this.repo});

  @override
  Future<Either<Failure, NotificationPaginationResponse>> call(NotificationPaginationRequest params) async{
   return await repo.getNotificationsByPagination(params);
  }
}
class CreateNotificationUsesCase extends UseCase<Unit,NotificationUser>{
  final NotificationsRepo repo;

  CreateNotificationUsesCase({required this.repo});

  @override
  Future<Either<Failure, Unit>> call(NotificationUser params) async{
   return await repo.createNotification(params);
  }
}class DeleteNotificationUsesCase extends UseCase<Unit,String>{
  final NotificationsRepo repo;

  DeleteNotificationUsesCase({required this.repo});

  @override
  Future<Either<Failure, Unit>> call(String params) async{
   return await repo.deleteNotification(params);
  }
}class UpdateSeenToTrueUsesCases extends UseCase<Unit,String>{
  final NotificationsRepo repo;

  UpdateSeenToTrueUsesCases({required this.repo});

  @override
  Future<Either<Failure, Unit>> call(String params) async{
   return await repo.updateSeenToTrue(params);
  }
}