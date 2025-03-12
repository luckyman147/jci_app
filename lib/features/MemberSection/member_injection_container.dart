

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/features/MemberSection/data/datasources/ObjectidDataSource.dart';
import 'package:jci_app/features/MemberSection/data/repositories/ObjectifRepoImpl.dart';
import 'package:jci_app/features/MemberSection/domain/entity/UserObjectifInfos.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/objectifsRepo.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/objectif_bloc.dart';

import 'domain/usecases/ObjectifUsesCase.dart';
import 'global-pres.dart';

final sl = GetIt.instance;

Future<void> initMembers() async {
  sl.registerFactory(() =>ObjectifBloc(sl(),sl()));
  sl.registerFactory(() => MembersBloc(sl(), sl(),sl(),sl(),sl(),sl(),sl()));
  sl.registerFactory(() => MemberManagementBloc(sl(), sl(),sl(),sl(),sl(),sl(),sl(),sl()));
sl.registerFactory(() => MemberPermissionBloc());

  sl.registerFactory(()=>ChangeSboolsCubit());
  //datasources

  sl.registerLazySingleton<MemberRemote>(() => MemberRemoteImpl(sl(),fire: sl()));
  sl.registerLazySingleton<MemberLocalDatasoources>(() => MemberLocalDatasoourcesImpl());
  sl.registerLazySingleton<ObjectifDataSource>(() => ObjectifDataSourcesImpl(firestore: sl()));


  //Repositories

  //UseCases
  ///objectifs
sl.registerLazySingleton(() => fetchUserWithHisObjectifsProgressUsesCase( objectifRepo: sl()));
sl.registerLazySingleton(() => AddObjectifUsesCase( objectifRepo: sl()));

///
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
  sl.registerLazySingleton<ObjectifRepo>(() => ObjectifRepoImpl(sl(),sl(),handler: sl()));
  sl.registerFactory(()=>Handler<({List<UserObjectifInfos> userObjectifInfos, DocumentSnapshot? lastDoc})>(sl(), networkInfo: sl()));

}