import 'package:encrypt_shared_preferences/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/MemberStore.dart';

import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/locale/app_localizations_delegate.dart';
import '../../core/config/services/FCMService/FCmServi.dart';
import '../../core/route/status/status_cubit.dart';
import '../changelanguages/presentation/bloc/locale_cubit.dart';
import 'data/datasources/UserAccountDataSource.dart';
import 'data/datasources/UserStatusRemoteDataSources.dart';
import 'data/datasources/authRemote.dart';

final sl = GetIt.instance;

Future<void> initAuth() async {
  sl.registerFactory(() => ResetBloc(sl(), sl(), sl()));
sl.registerFactory(() => localeCubit(sl()));
  sl.registerFactory(() => AuthBloc(
        sl(),
        refreshTokenUseCase: sl(),
        signoutUseCase: sl(),
      ));

  sl.registerFactory(() => SignUpBloc(
        signUpUseCase: sl(),
        sendVerificationEmailUseCase: sl(),
      ));
  sl.registerFactory(() => LoginBloc(
        sl(),
        sl(),
        googleSignUseCase: sl(),
      ));

  sl.registerLazySingleton<AuthRemote>(
      () => AuthRemoteImpl(sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton<UserStatusRemoteDataSource>(
      () => UserStatusRemoteDataSourceImpl(sl(), sl(), auth: sl()));
  sl.registerLazySingleton<UserAccountDataSource>(
      () => UserAccountDataSourceImpl(sl(), sl(), sl(), auth: sl()));

  // Replace with your implementation

//use cases

  //auth Uses Cases
  sl.registerLazySingleton(() => GoogleSignUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithPhoneUseCase(sl()));
  sl.registerLazySingleton(
      () => RegisterWithEmailUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignUpWithPhoneUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignOutUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(authRepository: sl()));
//user account use cases
  sl.registerLazySingleton(() => UpdatePasswordUseCase(userAccountRepo: sl()));
  sl.registerLazySingleton(() => IsNewMemberUseCase(userStatusRepo: sl()));
  sl.registerLazySingleton(() => GetPreviousEmailUseCase(authRepository: sl()));

  sl.registerLazySingleton(() => SendVerifyCodeUseCases(sl()));
  sl.registerLazySingleton(() => SendResetPasswordEmailUseCase(sl()));
  sl.registerLazySingleton(() => CheckOtpUseCase(sl()));

  sl.registerLazySingleton(
      () => RefreshTokenUseCase(userAccountRepository: sl()));

  // Repositories

  sl.registerLazySingleton<AuthRepo>(
      () => AuthRepositoryImpl(sl(), sl(), handler: sl()));
  sl.registerLazySingleton<UserStatusRepo>(
      () => UserStatusRepoImpl(sl(), userStatusRemoteDataSource: sl()));
  sl.registerLazySingleton<UserAccountRepo>(
      () => UserAccountRepoIml(handler: sl(), userAccountDataSource: sl()));

  //datasources
  // Register http.Client first

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
          'https://www.googleapis.com/auth/calendar',
          'https://www.googleapis.com/auth/calendar.events',
          'https://www.googleapis.com/auth/calendar.readonly',
          'https://www.googleapis.com/auth/calendar.events.readonly',
        ],
      ));
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

// Register other dependencies
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);


  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerFactory(() => MemberStore());

  sl.registerFactory(() => LanguageCacheHelper(store: sl()));

  // Register SignUpRemoteDataSource with http.Client as a parameter

  // Register repositories
}
