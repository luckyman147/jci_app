

import 'global-pres.dart';

final sl = GetIt.instance;

Future<void> initMembers() async {
  sl.registerFactory(() => MembersBloc(sl(), sl(),sl(),sl(),sl(),sl(),sl()));
  sl.registerFactory(() => MemberManagementBloc(sl(), sl(),sl(),sl(),sl(),sl(),sl(),sl()));
sl.registerFactory(() => MemberPermissionBloc());

  sl.registerFactory(()=>ChangeSboolsCubit());
  sl.registerLazySingleton<MemberRemote>(() => MemberRemoteImpl(client: sl()));
  sl.registerLazySingleton<MemberLocalDatasoources>(() => MemberLocalDatasoourcesImpl());


  //Repositories

  //UseCases
sl.registerLazySingleton(() => GetMembersByRanksUseCases( authRepository: sl()));
sl.registerLazySingleton(() => GetMemberByRankUseCase( authRepository: sl()));
sl.registerLazySingleton(() => SendInactivityReportUseCase( authRepository: sl()));
sl.registerLazySingleton(() => SendMembershipReportUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => GetAllMembersUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => ChangeLanguageUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => UpdateMemberUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => validateMemberuseCase( authRepository: sl()));
  sl.registerLazySingleton(() => UpdateCotisationUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => UpdatePointsUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => ChangeRoleUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => DeleteMemberUseCase( authRepository: sl()));

  sl.registerLazySingleton(() => GetMemberByIdUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => GetMemberByname( authRepository: sl()));
  sl.registerLazySingleton(() => GetUserProfile( authRepository: sl()));

  sl.registerLazySingleton<MemberRepo>(() => MemberRepoImpl(memberRemote: sl(), networkInfo: sl(), membersLocalDataSource: sl()));
}