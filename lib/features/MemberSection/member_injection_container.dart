import 'package:get_it/get_it.dart';
import 'package:jci_app/features/MemberSection/data/datasources/MemberLocalDataSources.dart';
import 'package:jci_app/features/MemberSection/data/datasources/MemberRemoteDataSources.dart';
import 'package:jci_app/features/MemberSection/data/repositories/MemberRepoImpl.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/MemberRepo.dart';
import 'package:jci_app/features/MemberSection/domain/usecases/MemberUseCases.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';

final sl = GetIt.instance;

Future<void> initMembers() async {
  sl.registerFactory(() => MembersBloc(sl(), sl(),sl(),sl()));

  sl.registerFactory(()=>ChangeSboolsCubit());
  sl.registerLazySingleton<MemberRemote>(() => MemberRemoteImpl(client: sl()));
  sl.registerLazySingleton<MemberLocalDatasoources>(() => MemberLocalDatasoourcesImpl());


  //Repositories

  //UseCases

  sl.registerLazySingleton(() => GetAllMembersUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => UpdateMemberUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => GetMemberByname( authRepository: sl()));
  sl.registerLazySingleton(() => GetUserProfile( authRepository: sl()));

  sl.registerLazySingleton<MemberRepo>(() => MemberRepoImpl(memberRemote: sl(), networkInfo: sl(), membersLocalDataSource: sl()));
}