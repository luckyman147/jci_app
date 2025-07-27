import 'package:get_it/get_it.dart';
import 'package:jci_app/core/config/services/uploadImage.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/MemberSection/data/repositories/AdminRepoImpl.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/AdminMemberRepo.dart';

import 'Notifications_dependencies.dart';
import 'data/Services/ObjectifLogicService.dart';
import 'data/repositories/MemberRepoImpl.dart';
import 'domain/repositories/MemberRepo.dart';
import 'member_dependencies.dart';

import 'objectif_dependencies.dart';

final sl = GetIt.instance;

Future<void> initMembers() async {

  sl.registerFactory(() => ObjectifService(sl(), firestore: sl(), logger: sl()));
  initObjectifDependencies();
  // Initialize feature-specific dependencies
  initMemberDependencies();

  initNotificationDependencies();

  // Register the main MemberRepo after all dependencies are ready
  sl.registerLazySingleton<MemberRepo>(() => MemberRepoImpl(
    memberRemote: sl(),
    membersLocalDataSource: sl(),
    membersListHandler: sl(),
    handler: sl(),
    memberHandler: sl(),
    UsersListHandler: sl(),

  ));
  // Register the main MemberRepo after all dependencies are ready
  sl.registerLazySingleton<AdminMemberRepo>(() => AdminRepoImpl(sl(),adminMemberOperations: sl ()

  ));
sl.registerFactory(()=>FunctionMember(store: sl()));

}