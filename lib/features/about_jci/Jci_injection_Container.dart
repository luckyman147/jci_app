
import 'package:get_it/get_it.dart';
import 'package:jci_app/features/about_jci/Domain/Repository/PresidentsRepo.dart';
import 'package:jci_app/features/about_jci/Domain/useCases/PresidentUseCAses.dart';
import 'package:jci_app/features/about_jci/data/datasources/LocalPresidentsDataSources.dart';
import 'package:jci_app/features/about_jci/data/datasources/RemotePresidentsDataSources.dart';

import 'Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'Presentations/bloc/presidents_bloc.dart';
import 'data/repository/PresidentRepoImpl.dart';

final sl = GetIt.instance;

Future<void> initJci() async {
  sl.registerFactory(() => PresidentsBloc(
    sl(),
         sl(),
         sl(),
      sl(),
        sl(),
      ));
  sl.registerFactory(()=>ActionJciCubit());
  sl.registerLazySingleton<LocalPresidentsDataSources>(()=>LocalPresidentsDataSourcesImpl());
  sl.registerLazySingleton<RemotePresidentsDataSources>(()=>RemotePresidentsDataSourcesImpl(client: sl()));
  sl.registerLazySingleton(()=>GetPresidentsUseCases( repo: sl()));
  sl.registerLazySingleton(()=>CreatePresidentUseCases( repo: sl()));
  sl.registerLazySingleton(()=>DeletePresidentUseCases( repo: sl()));
  sl.registerLazySingleton(()=>UpdateImagePresidentUseCases( repo: sl()));
  sl.registerLazySingleton(()=>UpdatePresidentUseCases( repo: sl()));
  
  
  
  sl.registerLazySingleton<PresidentsRepo>(() => PresidentRepoImpl(
    localPresidentsDataSources: sl(),
    remotePresidentsDataSources: sl(), networkInfo: sl(),
  ));
  
}