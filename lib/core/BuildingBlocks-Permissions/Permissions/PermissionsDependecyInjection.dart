
import 'package:get_it/get_it.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/DataSources/LocalPermissionsDataSources.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/PermissionsBLoc/permissions_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Dtos/LoadPermission.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../Handlers/Handler.dart';
import '../../config/services/permissionService/PermissionsStore.dart';
import 'Data/DataSources/RemotePermissionsDataSources.dart';
import 'Data/Repositories/PermissionRepoImpl.dart';
import 'domain/UseCases/PermissionsUseCases.dart';
import 'domain/repo/PermissionsRepositories.dart';

final sl = GetIt.instance;

Future<void> initPermissions() async {
  sl.registerLazySingleton(()=>PermissionsBloc(sl()));
  ///Datasources
    sl.registerLazySingleton<LocalDataSources>(
             () => LocalPermissionsDataSources(securePermissionStore: sl()));

    sl.registerLazySingleton<RemoteDataSources>(
             () => RemotePermissionsDataSourcesImpl(sl(), sl(), firestore: sl()));
  ///Usecases
  sl.registerLazySingleton(() => LoadUserPermissionsUseCase(sl()));
  sl.registerLazySingleton(() => LoadMasterPermissionsUseCase(sl()));
  sl.registerLazySingleton(() => CheckPermissionUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserPermissionsUseCase(sl()));
  //repos
  sl.registerLazySingleton<PermissionsRepository>(() => PemissionsRepoImpl(
      remoteDataSources: sl(),
      localDataSources: sl(), unitHandler: sl(), boolHandler: sl(), featurePermissionsHandler: sl()));

  sl.registerFactory(() => Handler<List<FeaturePermissions>>(sl(),networkInfo: sl()));
  sl.registerLazySingleton<SecurePermissionStore>(
          () => SecurePermissionStore(storage: sl()));
sl.registerLazySingleton(()=> const FlutterSecureStorage());
}