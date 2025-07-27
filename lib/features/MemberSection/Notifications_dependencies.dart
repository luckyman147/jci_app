import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:jci_app/features/MemberSection/data/Services/NotificationLogicService.dart';
import 'package:jci_app/features/MemberSection/data/datasources/NotificationsRemoteDataSources.dart';
import 'package:jci_app/features/MemberSection/data/repositories/NotificationRepoImpl.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/NotificationRepo.dart';
import 'package:jci_app/features/MemberSection/domain/usecases/NotificationUseCases.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Notifications/notification_bloc.dart';

import '../../core/Handlers/Handler.dart';
import 'domain/dto/NotificationPagintion.dart';

final sl = GetIt.instance;

void initNotificationDependencies() {
  // Bloc
  sl.registerFactory(() => NotificationBloc(sl(), sl(), sl(), sl()));

  // DataSources
  sl.registerLazySingleton<NotificationRemoteDataSources>(
          () => NotificationRemoteDataSourceImpl(sl(), notificationLogicService: sl(), firestore: sl())
  );

  // Services
  sl.registerFactory(() => NotificationLogicService());

  // Repositories
  sl.registerLazySingleton<NotificationsRepo>(
          () => NotificationRepoImpl(unitHandler: sl(), notificationRemoteDataSources: sl(), responseHandler: sl())
  );

  // UseCases
  sl.registerLazySingleton(() => CreateNotificationUsesCase(repo: sl()));
  sl.registerLazySingleton(() => DeleteNotificationUsesCase(repo: sl()));
  sl.registerLazySingleton(() => UpdateSeenToTrueUsesCases(repo: sl()));
  sl.registerLazySingleton(() => GetAllNotificationByPaginationUsesCase(repo: sl()));

  // Handlers
  sl.registerFactory(() => Handler<NotificationPaginationResponse>(sl(), networkInfo: sl()));
  sl.registerFactory(() => Handler<Unit>(sl(), networkInfo: sl()));
}