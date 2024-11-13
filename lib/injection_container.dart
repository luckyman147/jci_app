import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:jci_app/features/Home/Activity_Injection_container.dart';
import 'package:jci_app/features/MemberSection/member_injection_container.dart';
import 'package:jci_app/features/Teams/Team_injection_Container.dart';
import 'package:jci_app/features/about_jci/Jci_injection_Container.dart';

import 'package:jci_app/features/auth/auth%20_injection_container.dart';

import 'core/Handlers/Handler.dart';





final sl = GetIt.instance;

Future<void> init() async {
  // Replace with your implementation

  initTeams();
initActivities();
initJci();
initMembers();
initAuth();
  sl.registerFactory(() => Handler<Unit>(sl(),networkInfo: sl()));
  sl.registerFactory(() => Handler<dynamic>(sl(),networkInfo: sl()));
  sl.registerFactory(() => Handler<bool>(sl(),networkInfo: sl()));

}
