import 'package:get_it/get_it.dart';
import 'package:jci_app/features/Teams/data/%20repositories/TaskRepoImpl.dart';
import 'package:jci_app/features/Teams/data/%20repositories/TeamRepoImpl.dart';
import 'package:jci_app/features/Teams/data/datasources/TaskLocalDataSources.dart';
import 'package:jci_app/features/Teams/data/datasources/TaskRemoteDatasources.dart';
import 'package:jci_app/features/Teams/data/datasources/TeamLocalDataSources.dart';
import 'package:jci_app/features/Teams/data/datasources/TeamRemoteDatasources.dart';
import 'package:jci_app/features/Teams/domain/repository/TaskRepo.dart';
import 'package:jci_app/features/Teams/domain/repository/TeamRepo.dart';
import 'package:jci_app/features/Teams/domain/usecases/TeamUseCases.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/NumPages/num_pages_bloc.dart';

import 'package:jci_app/features/Teams/presentation/bloc/TaskFilter/taskfilter_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/Timeline/timeline_bloc.dart';


import 'domain/usecases/TaskUseCase.dart';

final sl = GetIt.instance;

Future<void> initTeams() async {

  //bloc

  sl.registerFactory(() => TimelineBloc());
  sl.registerFactory(() => TaskVisibleBloc());
  sl.registerFactory(() => TaskfilterBloc());

  sl.registerFactory(() => NumPagesBloc());
  sl.registerFactory(() => GetTaskBloc(addChecklistUseCase:sl(),
      getTasksOfTeamUseCase: sl(),
      getTasksByIdUseCase: sl(),
      addTaskUseCase: sl(),
      updateIsCompletedUseCases: sl(),
      deleteTaskUseCase: sl(),
      deleteChecklistUseCase: sl(),
      updateChecklistStatusUseCase: sl(),
      updateTaskNameUseCase: sl(), updateTaskTimelineUseCase: sl(),
      UpdateMembersUseCase: sl(), updateFileUseCase: sl (), deleteFileUseCase: sl(), updateChecklistNameUseCase: sl()));

  sl.registerFactory(() => GetTeamsBloc(sl(), sl()  ,sl(),sl(),sl(),sl()));
  //datasources

  sl.registerLazySingleton<TaskRemoteDataSource>(() => TaskRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<TeamRemoteDataSource>(() => TeamRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<TeamLocalDataSource>(() => TeamLocalDataSourceImpl());
  sl.registerLazySingleton<TaskLocalDataSource>(() => TaskLocalDataSourceImpl());
  //use cases
  sl.registerLazySingleton(() => AddChecklistUseCase(sl()));
  sl.registerLazySingleton(() => getTeamByNameUseCase(sl()));
  sl.registerLazySingleton(() => UpdateChecklistNameUseCase(sl()));

  sl.registerLazySingleton(() => DeleteFileUseCases(sl()));
  sl.registerLazySingleton(() => UpdateFileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMembersUsecases(sl()));
  sl.registerLazySingleton(() => DeleteChecklistUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskTimelineUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskNameUseCase(sl()));

  sl.registerLazySingleton(() => UpdateChecklistStatusUseCase(sl()));
  sl.registerLazySingleton(() => UpdateIsCompletedUseCases(sl()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksOfTeamUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksByIdUseCase(sl()));

  sl.registerLazySingleton(() => GetAllTeamsUseCase(sl()));
  sl.registerLazySingleton(() => GetTeamByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddTeamUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTeamUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTeamUseCase(sl()));

  //repo
  sl.registerLazySingleton<TeamRepo>(() => TeamRepoImpl(teamRemoteDataSource: sl(), teamLocalDataSource: sl(), networkInfo: sl(),));
  sl.registerLazySingleton<TaskRepo>(() => TaskRepoImpl(taskRemoteDataSource: sl(), taskLocalDataSource: sl(), networkInfo: sl(),));
}