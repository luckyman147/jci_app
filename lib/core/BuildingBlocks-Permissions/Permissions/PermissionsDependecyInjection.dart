import 'package:get_it/get_it.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/DataSources/LocalPermissionsDataSources.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/DataSources/RoleRemoteDatasources.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Repositories/RoleRepoImpl.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/features_cubit.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/roles/role__bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';

import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/UseCases/RoleUsesCases.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/repo/RoleRepo.dart';
import '../../Handlers/Handler.dart';
import '../../config/services/permissionService/PermissionsStore.dart';
import 'Data/DataSources/RemotePermissionsDataSources.dart';
import 'Data/Repositories/PermissionRepoImpl.dart';
import 'Presentation/Bloc/permissions/permissions_bloc.dart';
import 'domain/Entities/Feature.dart';
import 'domain/Entities/Role.dart';
import 'domain/UseCases/PermissionsUseCases.dart';
import 'domain/repo/PermissionsRepositories.dart';

final sl = GetIt.instance;

Future<void> initPermissions() async {
  sl.registerLazySingleton(() => PermissionsBloc(
        sl(),
      ));
  sl.registerLazySingleton(() => FeaturesCubit(
        sl(),
      ));
  sl.registerLazySingleton(() => RoleBloc(sl(), sl(), sl(), sl(), sl(), sl()));

  ///Datasources
  sl.registerLazySingleton<LocalDataSources>(
      () => LocalPermissionsDataSources(securePermissionStore: sl()));

  sl.registerLazySingleton<RemoteDataSources>(
      () => RemotePermissionsDataSourcesImpl(sl(), sl(), firestore: sl()));
  sl.registerLazySingleton<RoleRemoteDataSources>(
      () => RoleRemoteDataSourceImpl(firestore: sl(), logger: sl()));

  ///Usecases
  ///
  /// ²roles

  sl.registerLazySingleton(() => CreateRoleUsesCase(roleRepo: sl()));
  sl.registerLazySingleton(() => UpdateRoleInfoUseCase(roleRepo: sl()));
  sl.registerLazySingleton(() => UpdateRolePermissionsUseCase(roleRepo: sl()));
  sl.registerLazySingleton(() => ChangeRoleOfUserUseCase(roleRepo: sl()));
  sl.registerLazySingleton(() => FetchRoleByNameUseCase(roleRepo: sl()));
  sl.registerLazySingleton(() => FetchRolesUseCase(roleRepo: sl()));

  sl.registerLazySingleton(() => LoadUserPermissionsUseCase(sl()));
  sl.registerLazySingleton(
      () => FetchFeaturesUsesCases(permissionsRepository: sl()));
  sl.registerLazySingleton(() => LoadMasterPermissionsUseCase(sl()));
  sl.registerLazySingleton(() => CheckPermissionUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserPermissionsUseCase(sl()));
  //repos
  sl.registerLazySingleton<RoleRepo>(() => RoleRepoImpl(
      roleRemoteDataSources: sl(),
      handler: sl(),
      rolehandler: sl(),
      roleshandler: sl()));
  sl.registerLazySingleton<PermissionsRepository>(() => PemissionsRepoImpl(sl(),
      remoteDataSources: sl(),
      localDataSources: sl(),
      unitHandler: sl(),
      boolHandler: sl(),
      featurePermissionsHandler: sl()));

  sl.registerFactory(() => Handler<List<Role>>(sl(), networkInfo: sl()));
  sl.registerFactory(() => Handler<Role>(sl(), networkInfo: sl()));
  sl.registerFactory(
      () => Handler<List<FeaturePermissions>>(sl(), networkInfo: sl()));
  sl.registerFactory(() => Handler<List<Feature>>(sl(), networkInfo: sl()));
  sl.registerLazySingleton<SecurePermissionStore>(
      () => SecurePermissionStore(storage: sl()));
}
