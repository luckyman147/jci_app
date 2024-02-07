import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jci_app/features/auth/data/datasources/LoginRemote.dart';
import 'package:jci_app/features/auth/data/datasources/signUpRemote.dart';
import 'package:jci_app/features/auth/data/repositories/LoginRepoImpl.dart';
import 'package:jci_app/features/auth/data/repositories/signUpRepoImpl.dart';
import 'package:jci_app/features/auth/domain/repositories/AuthRepo.dart';
import 'package:jci_app/features/auth/domain/repositories/LoginRepo.dart';
import 'package:jci_app/features/auth/domain/repositories/SignUpRepo.dart';
import 'package:jci_app/features/auth/domain/usecases/SIgnIn.dart';
import 'package:jci_app/features/auth/domain/usecases/SignUp.dart';
import 'package:jci_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:secure_shared_preferences/secure_shared_pref.dart';
import 'core/network/network_info.dart';


final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => SignUpBloc(
    signUpUseCase: sl(),

));
  sl.registerFactory(()=>LoginBloc( sl()));
  sl.registerLazySingleton<LoginRemoteDataSource>(
          () => LoginRemoteDataSourceImpl(client: sl()));

//use cases
  sl.registerLazySingleton(() => SignUpUseCase(authRepo: sl()));
  sl.registerLazySingleton(() => LoginUseCase( sl()));

  // Repositories
  sl.registerLazySingleton<SignUpRepo>(() => SignUpRepoImpl(sl(),  sl()));
  sl.registerLazySingleton<LoginRepo>(() => LoginRepoImpl( loginRemoteDataSource: sl(), networkInfo: sl(), ));
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
