import 'package:get_it/get_it.dart';
import 'package:jci_app/features/MemberSection/data/datasources/MemberLocalDataSources.dart';
import 'package:jci_app/features/MemberSection/data/datasources/MemberRemoteDataSources.dart';
import 'package:jci_app/features/MemberSection/data/repositories/MemberRepoImpl.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/MemberRepo.dart';
import 'package:jci_app/features/MemberSection/domain/usecases/MemberUseCases.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';

final sl = GetIt.instance;

Future<void> initMembers() async {
  sl.registerFactory(() => MembersBloc(sl(), sl(),sl(),sl(),sl(),sl()));
  sl.registerFactory(() => MemberManagementBloc(sl(), sl(),sl(),sl(),sl(),sl(),sl()));

  sl.registerFactory(()=>ChangeSboolsCubit());
  sl.registerLazySingleton<MemberRemote>(() => MemberRemoteImpl(client: sl()));
  sl.registerLazySingleton<MemberLocalDatasoources>(() => MemberLocalDatasoourcesImpl());


  //Repositories

  //UseCases
sl.registerLazySingleton(() => GetMembersByRanksUseCases( authRepository: sl()));
sl.registerLazySingleton(() => SendInactivityReportUseCase( authRepository: sl()));
sl.registerLazySingleton(() => SendMembershipReportUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => GetAllMembersUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => ChangeLanguageUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => UpdateMemberUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => validateMemberuseCase( authRepository: sl()));
  sl.registerLazySingleton(() => UpdateCotisationUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => UpdatePointsUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => ChangeRoleUseCase( authRepository: sl()));

  sl.registerLazySingleton(() => GetMemberByIdUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => GetMemberByname( authRepository: sl()));
  sl.registerLazySingleton(() => GetUserProfile( authRepository: sl()));

  sl.registerLazySingleton<MemberRepo>(() => MemberRepoImpl(memberRemote: sl(), networkInfo: sl(), membersLocalDataSource: sl()));
}