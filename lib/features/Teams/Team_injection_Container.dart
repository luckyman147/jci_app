import 'package:get_it/get_it.dart';
import 'package:jci_app/features/Teams/data/%20repositories/TeamRepoImpl.dart';
import 'package:jci_app/features/Teams/data/datasources/TeamLocalDataSources.dart';
import 'package:jci_app/features/Teams/data/datasources/TeamRemoteDatasources.dart';
import 'package:jci_app/features/Teams/domain/repository/TeamRepo.dart';
import 'package:jci_app/features/Teams/domain/usecases/TeamUseCases.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TeamActions/team_actions_bloc.dart';

final sl = GetIt.instance;

Future<void> initTeams() async {
  //bloc
sl.registerFactory(() => TeamActionsBloc(sl(), sl(),sl()  ));
  sl.registerFactory(() => GetTeamsBloc(sl(), sl()  ));
  //datasources
  sl.registerLazySingleton<TeamRemoteDataSource>(() => TeamRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<TeamLocalDataSource>(() => TeamLocalDataSourceImpl());
  //use cases
  sl.registerLazySingleton(() => GetAllTeamsUseCase(sl()));
  sl.registerLazySingleton(() => GetTeamByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddTeamUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTeamUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTeamUseCase(sl()));

  //repo
  sl.registerLazySingleton<TeamRepo>(() => TeamRepoImpl(teamRemoteDataSource: sl(), teamLocalDataSource: sl(), networkInfo: sl(),));
}