import 'package:get_it/get_it.dart';
import 'package:jci_app/features/projectFeature/data/datasources/ProjectLocalDataSources.dart';
import 'package:jci_app/features/projectFeature/data/datasources/ProjectRemoteDataSources.dart';
import 'package:jci_app/features/projectFeature/presentation/bloc/Project/project_management_bloc.dart';
import 'package:jci_app/features/projectFeature/presentation/enum/ProjectCreationStep.dart';
import 'package:jci_app/features/projectFeature/service/ProjectStore.dart';

import '../../core/Handlers/Handler.dart';
import 'data/repositories/ProjectRepositoryImpl.dart';
import 'domain/entities/Project.dart';
import 'domain/repositories/projectRepositories.dart';
import 'domain/usescases/ProjectUseCases.dart';

final sl = GetIt.instance;

Future<void> initProjectFeature() async {

  // Register your project feature dependencies here
  // Example:
   sl.registerFactory(() => ProjectManagementBloc(createProjectUseCase: sl(),
       updateProjectUseCase: sl(), deleteProjectUseCase:sl(),
       getAllProjectsUseCase:sl(), getProjectByIdUseCase:sl(),
       saveDraftProjectUseCase: sl(), clearProjectUseCase:
       sl(), getDraftProjectUseCase: sl (), deleteTeamUseCase:sl()));
   sl.registerLazySingleton<ProjectLocalDataSources>(
           () => ProjectLocalDataSourcesImpl( sl()));
   sl.registerLazySingleton<ProjectRemoteDataSources>(
           () => ProjectRemoteDataSourcesImpl(sl(),firestore: sl()));
    // Use cases
    sl.registerLazySingleton(() => CreateProjectUseCase(sl()));
    sl.registerLazySingleton(() => UpdateProjectUseCase(sl()));
    sl.registerLazySingleton(() => DeleteProjectUseCase(sl()));
    sl.registerLazySingleton(() => GetAllProjectsUseCase(sl()));
    sl.registerLazySingleton(() => GetProjectByIdUseCase(sl()));
    sl.registerLazySingleton(() => SaveDraftProjectUseCase(sl()));
    sl.registerLazySingleton(() => ClearProjectUseCase(sl()));
    sl.registerLazySingleton(() => GetDraftProjectUseCase(sl()));
    sl.registerLazySingleton(() => deleteTeamFromProjectUseCase(sl()));
  // Register other dependencies as needed
  // repositories
  sl.registerLazySingleton<ProjectRepository>(() => ProjectRepositoryImpl(
      handler: sl(),
    projectHandler: sl(),
    projectsHandler: sl(), unitHandler: sl(), remoteDataSource: sl(), localDataSource: sl(),


  ));
   sl.registerFactory(() => ProjectStore(sl()));
   registerHandler<Project>();
   registerHandler<List<Project>>();
   registerHandler<ProjectCreationStatus>();



}
void registerHandler<T>() {
  sl.registerFactory<Handler<T>>(() => Handler<T>(sl(), networkInfo: sl()));
}
