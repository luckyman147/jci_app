
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jci_app/features/auth/data/datasources/authRemote.dart';
import 'package:jci_app/features/auth/data/repositories/auth.dart';
import 'package:jci_app/features/auth/domain/repositories/AuthRepo.dart';

import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';


import '../../core/network/network_info.dart';

import 'data/datasources/authLocal.dart';

import 'package:http/http.dart' as http;

import 'domain/usecases/authusecase.dart';

final sl = GetIt.instance;

Future <void > initAuth()async{
  sl.registerFactory(() => ResetBloc(sl(),sl(),sl()));

sl.registerFactory(() => AuthBloc(
     refreshTokenUseCase: sl(), signoutUseCase: sl(),
  ));

  sl.registerFactory(() => SignUpBloc(
    signUpUseCase: sl(), sendVerificationEmailUseCase: sl(),
  ));
  sl.registerFactory(
          () => LoginBloc(loginUseCase: sl(),));



sl.registerLazySingleton<AuthRemote>(() => AuthRemoteImpl(client: sl()));
sl.registerLazySingleton<AuthLocalDataSources>(() => AuthLocalImpl());




//use cases

  sl.registerLazySingleton(() => UpdatePasswordUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SendVerifyCodeUseCases( sl()));
  sl.registerLazySingleton(() => SendResetPasswordEmailUseCase( sl()));
  sl.registerLazySingleton(() => CheckOtpUseCase( sl()));
  sl.registerLazySingleton(() => SignOutUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase( authRepository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase( authRepository: sl  ()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repositories

sl.registerLazySingleton<AuthRepo>(() => AuthRepositoryImpl(api: sl(), networkInfo: sl(), local: sl(), ));

  //datasources
  // Register http.Client first

  sl.registerLazySingleton(() => http.Client());

  // Register other dependencies
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Register SignUpRemoteDataSource with http.Client as a parameter

  // Register repositories
}