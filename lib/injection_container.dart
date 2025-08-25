import 'package:dartz/dartz.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/PermissionsDependecyInjection.dart';
import 'package:jci_app/core/config/services/verification.dart';
import 'package:jci_app/core/route/app_router.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/Home/Activity_Injection_container.dart';
import 'package:jci_app/features/MemberSection/member_di_container.dart';
import 'package:jci_app/features/Teams/Team_injection_Container.dart';
import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:jci_app/features/about_jci/Domain/entities/President.dart';
import 'package:jci_app/features/about_jci/Jci_injection_Container.dart';

import 'package:jci_app/features/auth/auth%20_injection_container.dart';
import 'package:jci_app/features/projectFeature/ProjectDi.dart';

import 'core/Handlers/Handler.dart';
import 'core/config/services/FCMService/FCmServi.dart';
import 'core/di/Services/FCMServive.dart';
import 'core/di/Services/Firebase_Service.dart';
import 'core/di/Services/app_check_service.dart';
import 'core/di/Services/app_initialize.dart';
import 'core/mixins/Loggable.dart';
import 'core/route/StatusGuard.dart';
import 'core/route/status/status_cubit.dart';
import 'features/Home/domain/entities/Category.dart';
import 'features/Teams/domain/entities/task/Task.dart';
import 'features/auth/AuthWidgetGlobal.dart';





final sll = GetIt.instance;

Future<void> init() async {
  // Replace with your implementation
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await Hive.openBox('secureBox');
  await Hive.openBox('memberBox');

  sll.registerFactory(() => Store());

  sll.registerLazySingleton(() => FirebaseService());
  sll.registerLazySingleton<StatusCubit>(() => StatusCubit( sll()));
  sll.registerLazySingleton(() => StatusGuard());
  sll.registerLazySingleton(() => AppRouter(
    sll()
  ));
  sll.registerLazySingleton<Logger>(() => Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  ));
  sll.registerLazySingleton(() => FSMToken(store: sll()));
  sll.registerLazySingleton(() => FCMService());
  sll.registerLazySingleton(() => AppCheckService());

  sll.registerLazySingleton(() => AppInitializer(
    sll<FirebaseService>(),

    sll<FCMService>(),
    sll<AppCheckService>(),
  ));

await initAuth();
 await  initTeams();
initActivities();
initJci();
await initMembers();
initPermissions();
 
registerAllHandlers();
initProjectFeature();
}
void registerHandler<T>() {
  sll.registerFactory<Handler<T>>(() => Handler<T>(sll(), networkInfo: sll()));
}
void registerAllHandlers() {
  registerHandler<dynamic>();
  registerHandler<bool>();
  registerHandler<Activity>();
  registerHandler<List<Activity>>();
  registerHandler<String>();
  registerHandler<List<Category>>();
  registerHandler<Category>();
  registerHandler<List<Team>>();
  registerHandler<Team>();
  registerHandler<List<Tasks>>();
  registerHandler<Tasks>();
  registerHandler<UploadProgress>();
  registerHandler<TaskFile>();
  registerHandler<CheckList>();
  registerHandler<List<CheckList>>();
  registerHandler<List<President>>();
  registerHandler<(List<President>, DocumentSnapshot?)>();
  registerHandler<({List<Team> Teams, DocumentSnapshot? lastDoc})>();
}