
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jci_app/features/auth/data/datasources/authRemote.dart';
import 'package:jci_app/features/auth/data/repositories/auth.dart';
import 'package:jci_app/features/auth/domain/repositories/AuthRepo.dart';
import 'package:jci_app/features/auth/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';


import '../../core/network/network_info.dart';
import 'data/datasources/LoginRemote.dart';
import 'data/datasources/authLocal.dart';
import 'data/datasources/signUpRemote.dart';
import 'data/repositories/LoginRepoImpl.dart';
import 'data/repositories/signUpRepoImpl.dart';
import 'domain/repositories/LoginRepo.dart';
import 'domain/repositories/SignUpRepo.dart';
import 'domain/usecases/SIgnIn.dart';
import 'domain/usecases/SignUp.dart';
import 'package:http/http.dart' as http;

import 'domain/usecases/authusecase.dart';

final sl = GetIt.instance;

Future <void > initAuth()async{
  sl.registerFactory(() => ResetBloc(sl()));

sl.registerFactory(() => AuthBloc(
     refreshTokenUseCase: sl(), signoutUseCase: sl(),
  ));
sl.registerFactory(() => MembersBloc(
    sl(),sl()
  ));
  sl.registerFactory(() => SignUpBloc(
    signUpUseCase: sl(),
  ));
  sl.registerFactory(
          () => LoginBloc(loginUseCase: sl(),));


  sl.registerLazySingleton<LoginRemoteDataSource>(
          () => LoginRemoteDataSourceImpl(

        client: sl(), auth: sl(),
      ));
sl.registerLazySingleton<AuthRemote>(() => AuthRemoteImpl(client: sl()));
sl.registerLazySingleton<MembersLocalDataSource>(() => MembersLocalDataSourceImpl());



//use cases
sl.registerLazySingleton(() => GetAllMembersUseCase(authRepository: sl()));
sl.registerLazySingleton(() => GetMemberByname(authRepository: sl()));
  sl.registerLazySingleton(() => GetUserProfile(authRepository: sl()));
  sl.registerLazySingleton(() => UpdatePasswordUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignOutUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(authRepo: sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repositories

sl.registerLazySingleton<AuthRepo>(() => AuthRepositoryImpl(api: sl(), networkInfo: sl(), membersLocalDataSource: sl()));
  sl.registerLazySingleton<SignUpRepo>(() => SignUpRepoImpl(sl(), sl()));
  sl.registerLazySingleton<LoginRepo>(() => LoginRepoImpl(
    loginRemoteDataSource: sl(),
    networkInfo: sl(),
  ));
  //datasources
  // Register http.Client first

  sl.registerLazySingleton(() => http.Client());

  // Register other dependencies
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Register SignUpRemoteDataSource with http.Client as a parameter
  sl.registerLazySingleton<SignUpRemoteDataSource>(
          () => SignUpRemoteDataSourceImpl(client: sl()));

  // Register repositories
}