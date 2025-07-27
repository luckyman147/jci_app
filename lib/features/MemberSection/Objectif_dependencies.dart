import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:jci_app/features/MemberSection/data/datasources/ObjectidDataSource.dart';
import 'package:jci_app/features/MemberSection/data/repositories/ObjectifRepoImpl.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/objectifsRepo.dart';
import 'package:jci_app/features/MemberSection/domain/usecases/ObjectifUsesCase.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/objectif_bloc.dart';

import '../../core/Handlers/Handler.dart';
import 'domain/entity/UserObjectifInfos.dart';

final sl = GetIt.instance;

void initObjectifDependencies() {
  // Blocs
  sl.registerFactory(() => ObjectifBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => UserObjectifProgressCubit(sl(), sl()));

  // DataSources
  sl.registerLazySingleton<ObjectifDataSource>(
          () => ObjectifDataSourcesImpl(firestore: sl(), objectiveService: sl())
  );

  // Repositories
  sl.registerLazySingleton<ObjectifRepo>(
          () => ObjectifRepoImpl(sl(), sl(), sl(), handler: sl())
  );

  // UseCases
  sl.registerLazySingleton(() => fetchUserWithHisObjectifsProgressUsesCase(objectifRepo: sl()));
  sl.registerLazySingleton(() => AddObjectifUsesCase(objectifRepo: sl()));
  sl.registerLazySingleton(() => DeleteObjectifUsesCase(objectifRepo: sl()));
  sl.registerLazySingleton(() => UpdateObjectifUsesCase(objectifRepo: sl()));
  sl.registerLazySingleton(() => updateUserObjectivesProgressUsesCase(objectifRepo: sl()));

  // Handlers
  sl.registerFactory(() => Handler<({List<UserObjectifInfos> userObjectifInfos, DocumentSnapshot? lastDoc})>(sl(), networkInfo: sl()));
  sl.registerFactory(() => Handler<List<UserObjectifInfos>>(sl(), networkInfo: sl()));
}