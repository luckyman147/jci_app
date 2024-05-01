
import 'package:get_it/get_it.dart';
import 'package:jci_app/features/about_jci/Domain/Repository/BoardRepo.dart';
import 'package:jci_app/features/about_jci/Domain/Repository/PresidentsRepo.dart';
import 'package:jci_app/features/about_jci/Domain/useCases/BoardUseCases.dart';
import 'package:jci_app/features/about_jci/Domain/useCases/PresidentUseCAses.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/BoardBloc/boord_bloc.dart';
import 'package:jci_app/features/about_jci/data/datasources/Board/LocalBoardDataSources.dart';
import 'package:jci_app/features/about_jci/data/datasources/Board/RemoteBoardDataSources.dart';
import 'package:jci_app/features/about_jci/data/datasources/LocalPresidentsDataSources.dart';
import 'package:jci_app/features/about_jci/data/datasources/RemotePresidentsDataSources.dart';
import 'package:jci_app/features/about_jci/data/repository/BoardRepoImpl.dart';

import 'Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'Presentations/bloc/Board/YearsBloc/years_bloc.dart';
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

  sl.registerFactory(() => YearsBloc(sl(),sl(),sl(),sl(),sl(),sl ()));
  sl.registerFactory(() => BoordBloc(sl(),sl(),sl(),sl(),sl()));

  sl.registerFactory(()=>ActionJciCubit());
  sl.registerLazySingleton<LocalPresidentsDataSources>(()=>LocalPresidentsDataSourcesImpl());
  sl.registerLazySingleton<RemotePresidentsDataSources>(()=>RemotePresidentsDataSourcesImpl(client: sl())); 
  sl.registerLazySingleton<LocalBoardDataSources>(()=>LocalBoardDataSourcesImpl());
  sl.registerLazySingleton<RemoteBoardDataSources>(()=>RemoteBoardDataSourcesImpl(client: sl()));
  
  sl.registerLazySingleton(()=>AddRoleUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>RemoveRoleUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>AddPositionUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>RemovePositionUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>AddMemberBoardUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>RemoveMemberBoardUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>getYearsUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>getBoardRolesUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>RemoveBoardUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>AddBoardUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>GetBoardByYearUseCase( boardRepo: sl()));
  sl.registerLazySingleton(()=>GetPresidentsUseCases( repo: sl()));
  sl.registerLazySingleton(()=>CreatePresidentUseCases( repo: sl()));
  sl.registerLazySingleton(()=>DeletePresidentUseCases( repo: sl()));
  sl.registerLazySingleton(()=>UpdateImagePresidentUseCases( repo: sl()));
  sl.registerLazySingleton(()=>UpdatePresidentUseCases( repo: sl()));
  
  
  
  sl.registerLazySingleton<BoardRepo>(() => BoardRepoImpl(
    localBoardDataSources: sl(),
    remoteBoardDataSources: sl(), networkInfo: sl(),
  ));
  sl.registerLazySingleton<PresidentsRepo>(() => PresidentRepoImpl(
    localPresidentsDataSources: sl(),
    remotePresidentsDataSources: sl(), networkInfo: sl(),
  ));
  
}