import 'package:get_it/get_it.dart';

import 'package:jci_app/features/Teams/data/datasources/TaskLocalDataSources.dart';
import 'package:jci_app/features/Teams/data/datasources/TaskRemoteDatasources.dart';
import 'package:jci_app/features/Teams/data/datasources/TeamLocalDataSources.dart';
import 'package:jci_app/features/Teams/data/datasources/TeamRemoteDatasources.dart';
import 'package:jci_app/features/Teams/data/repositories/TaskRepoImpl.dart';
import 'package:jci_app/features/Teams/data/repositories/TeamRepoImpl.dart';
import 'package:jci_app/features/Teams/domain/repository/Tasks/TaskRepo.dart';
import 'package:jci_app/features/Teams/domain/repository/TeamRepo.dart';
import 'package:jci_app/features/Teams/domain/usecases/TeamUseCases.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/NumPages/num_pages_bloc.dart';

import 'package:jci_app/features/Teams/presentation/bloc/TaskFilter/taskfilter_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/Timeline/timeline_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/members/members_cubit.dart';

import 'data/datasources/ChecklistRemoteDataSources.dart';
import 'domain/usecases/CheckList_usescases.dart';
import 'domain/usecases/TaskUseCase.dart';
import 'domain/usecases/comments_files_usecases.dart';

final sl = GetIt.instance;

Future<void> initTeams() async {
  //bloc
  sl.registerFactory(() => MembersTeamCubit());
  sl.registerFactory(() => TimelineBloc());
  sl.registerFactory(() => TaskVisibleBloc());
  sl.registerFactory(() => TaskfilterBloc());

  sl.registerFactory(() => NumPagesBloc());
  sl.registerFactory(() => GetTaskBloc(

      getTasksOfTeamUseCase: sl(),
      getTasksByIdUseCase: sl(),
      addTaskUseCase: sl(),

      deleteTaskUseCase: sl(),


      updateTaskTimelineUseCase: sl(), updateMembersUseCase: sl(), UpdateTaskNameUseCase: sl(),
));

  sl.registerFactory(() =>
      GetTeamsBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  //datasources

  sl.registerLazySingleton<TaskRemoteDataSource>(
      () => TaskFirestoreRemote( sl()));
  sl.registerLazySingleton<ChecklistRemoteDataSource>(
      () => ChecklistRemoteDataSourceImpl( sl()));
  sl.registerLazySingleton<ChecklistRemoteDataSource>(
      () => ChecklistRemoteDataSourceImpl( sl()));
  sl.registerLazySingleton<TeamRemoteDataSource>(
      () => TeamRemoteDataSourceImpl(sl(), sl(),sl(),sl(),sl()));
  sl.registerLazySingleton<TeamLocalDataSource>(
      () => TeamLocalDataSourceImpl());
  sl.registerLazySingleton<TaskLocalDataSource>(
      () => TaskLocalDataSourceImpl());
  //use cases
  sl.registerLazySingleton(() => AddChecklistUseCase(sl()));
  sl.registerLazySingleton(() => getTeamByNameUseCase(sl()));
  sl.registerLazySingleton(() => UpdateChecklistNameUseCase(sl()));
  sl.registerLazySingleton(() => AddCommentUseCase(sl()));

  sl.registerLazySingleton(() => DeleteFileUseCase(sl()));
  sl.registerLazySingleton(() => updateTaskNameUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMembersUseCase(sl()));
  sl.registerLazySingleton(() => DeleteChecklistUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskTimeline(sl()));
  sl.registerLazySingleton(() => updateTaskNameUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTeamMembersUseCase(sl()));
  //sl.registerLazySingleton(() => GetFil(sl()));

  sl.registerLazySingleton(() => UpdateChecklistStatusUseCase(sl()));
  sl.registerLazySingleton(() => InviteMemberUseCase(sl()));
  sl.registerLazySingleton(() => updateTaskStatusUseCase(sl()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetTasksOfTeamUseCase(sl()));
  sl.registerLazySingleton(() => GetTaskByIdUseCase(sl()));

  sl.registerLazySingleton(() => GetAllTeamsUseCase(sl()));
  sl.registerLazySingleton(() => JoinTeamUseCase(sl()));
  sl.registerLazySingleton(() => GetTeamByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddTeamUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTeamUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTeamUseCase(sl()));

  //repo
  sl.registerLazySingleton<TeamRepo>(() => TeamRepoImpl(
    sl(),sl(),sl(),sl(),
        teamRemoteDataSource: sl(),
        teamLocalDataSource: sl(),
        networkInfo: sl(),
      ));
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(
   sl(),sl(),sl(),remote: sl(), local: sl(),
      ));
}
