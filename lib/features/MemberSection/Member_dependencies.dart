import 'package:get_it/get_it.dart';
import 'package:jci_app/core/config/services/uploadImage.dart';
import 'package:jci_app/features/MemberSection/data/datasources/members/AdminMemberOperations.dart';
import 'package:jci_app/features/MemberSection/data/datasources/members/MemberLocalDataSources.dart';
import 'package:jci_app/features/MemberSection/data/datasources/members/MemberRemoteDataSources.dart';
import 'package:jci_app/features/MemberSection/data/repositories/MemberRepoImpl.dart';
import 'package:jci_app/features/MemberSection/domain/usecases/MemberUseCases.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberPermissions/member_permission_bloc.dart';

import '../../core/Handlers/Handler.dart';
import '../../core/Member.dart';
import '../../core/PrimitiveUser/User.dart';
import 'domain/usecases/AdminMembersUsesCase.dart';

final sl = GetIt.instance;

void initMemberDependencies() {
  // Blocs
  sl.registerFactory(() => MembersBloc(
      store: sl(),
      getAllMembersUseCase: sl(),
      getMemberByNameUseCase: sl(),
      getUserProfileUseCase: sl(),
      updateMemberUseCase: sl(),
      getMemberByIdUseCase: sl(),
      getMembersByRanksUseCases: sl(),
      getMembeWithHighestRankUseCase: sl()));
  sl.registerFactory(() => MemberManagementBloc(
      validateMemberUseCase: sl(),
      updateCotisationUseCase: sl(),
      updatePointsUseCase: sl(),
      changeLanguageUseCase: sl(),
      deleteMemberUseCase: sl()));
  sl.registerFactory(() => MemberPermissionBloc(sl()));
  sl.registerFactory(() => ChangeSboolsCubit());

  // DataSources
  sl.registerLazySingleton<MemberRemote>(() => MemberRemoteImpl(sl(),
      firebaseImageUploader: sl(), fire: sl(), logger: sl(), store: sl()));
  sl.registerLazySingleton<AdminMemberOperations>(
      () => AdminMemberOperationsImpl(sl(), fire: sl()));
  sl.registerLazySingleton<MemberLocalDatasoources>(
      () => MemberLocalDatasoourcesImpl(memberStore: sl()));

  // UseCases
  sl.registerLazySingleton(
      () => GetMembersByRanksUseCases(authRepository: sl()));
  sl.registerLazySingleton(() => GetMemberByRankUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => GetAllMembersUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => ChangeLanguageUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => UpdateMemberUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => validateMemberuseCase(adminMemberRepo: sl()));
  sl.registerLazySingleton(
      () => UpdateCotisationUseCase(adminMemberRepo: sl()));
  sl.registerLazySingleton(() => UpdatePointsUseCase(adminMemberRepo: sl()));
  sl.registerLazySingleton(() => DeleteMemberUseCase(adminMemberRepo: sl()));
  sl.registerLazySingleton(() => GetMemberByIdUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => GetMemberByname(authRepository: sl()));
  sl.registerLazySingleton(() => GetUserProfile(authRepository: sl()));

  // Handlers
  sl.registerFactory(() => Handler<List<Member>>(sl(), networkInfo: sl()));
  sl.registerFactory(() => Handler<Member>(sl(), networkInfo: sl()));
}
