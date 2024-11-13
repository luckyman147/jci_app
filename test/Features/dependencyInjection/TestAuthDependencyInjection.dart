import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:jci_app/features/auth/domain/repositories/AuthRepo.dart';
import 'package:jci_app/features/auth/domain/repositories/UserAccountRepo.dart';
import 'package:jci_app/features/auth/domain/repositories/UserStatusRepo.dart';
import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:mockito/mockito.dart';

import  'package:http/http.dart' as http;

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;


void main(){
  setUp(setupAuthTestDependencies);

  tearDown(() => sl.reset());
  test('should register and retrieve AuthRemote', () {
    final authRemote = sl<AuthRemote>();
    expect(authRemote, isA<AuthRemote>());
  });

  test('should register and retrieve UserStatusRemoteDataSource', () {
    final userStatusRemoteDataSource = sl<UserStatusRemoteDataSource>();
    expect(userStatusRemoteDataSource, isA<UserStatusRemoteDataSource>());
  });

  test('should register and retrieve UserAccountDataSource', () {
    final userAccountDataSource = sl<UserAccountDataSource>();
    expect(userAccountDataSource, isA<UserAccountDataSource>());
  });

  test('should register and retrieve AuthRepo', () {
    final authRepo = sl<AuthRepo>();
    expect(authRepo, isA<AuthRepo>());
  });

  test('should register and retrieve UserAccountRepo', () {
    final userAccountRepo = sl<UserAccountRepo>();
    expect(userAccountRepo, isA<UserAccountRepo>());
  });

  test('should register and retrieve UserStatusRepo', () {
    final userStatusRepo = sl<UserStatusRepo>();
    expect(userStatusRepo, isA<UserStatusRepo>());
  });

  test('should register and retrieve SignOutUseCase', () {
    final signOutUseCase = sl<SignOutUseCase>();
    expect(signOutUseCase, isA<SignOutUseCase>());
  });




  test('should register and retrieve LoginWithEmailUseCase', () {
    final useCase = sl<LoginWithEmailUseCase>();
    expect(useCase, isA<LoginWithEmailUseCase>());
  });

  test('should register and retrieve LoginWithPhoneUseCase', () {
    final useCase = sl<LoginWithPhoneUseCase>();
    expect(useCase, isA<LoginWithPhoneUseCase>());
  });

  test('should register and retrieve RegisterWithEmailUseCase', () {
    final useCase = sl<RegisterWithEmailUseCase>();
    expect(useCase, isA<RegisterWithEmailUseCase>());
  });

  test('should register and retrieve SignUpWithPhoneUseCase', () {
    final useCase = sl<SignUpWithPhoneUseCase>();
    expect(useCase, isA<SignUpWithPhoneUseCase>());
  });

  test('should register and retrieve SignOutUseCase', () {
    final useCase = sl<SignOutUseCase>();
    expect(useCase, isA<SignOutUseCase>());
  });

  test('should register and retrieve IsLoggedInUseCase', () {
    final useCase = sl<IsLoggedInUseCase>();
    expect(useCase, isA<IsLoggedInUseCase>());
  });

  test('should register and retrieve UpdatePasswordUseCase', () {
    final useCase = sl<UpdatePasswordUseCase>();
    expect(useCase, isA<UpdatePasswordUseCase>());
  });

  test('should register and retrieve IsNewMemberUseCase', () {
    final useCase = sl<IsNewMemberUseCase>();
    expect(useCase, isA<IsNewMemberUseCase>());
  });

  test('should register and retrieve GetPreviousEmailUseCase', () {
    final useCase = sl<GetPreviousEmailUseCase>();
    expect(useCase, isA<GetPreviousEmailUseCase>());
  });

  test('should register and retrieve SendVerifyCodeUseCases', () {
    final useCase = sl<SendVerifyCodeUseCases>();
    expect(useCase, isA<SendVerifyCodeUseCases>());
  });

  test('should register and retrieve SendResetPasswordEmailUseCase', () {
    final useCase = sl<SendResetPasswordEmailUseCase>();
    expect(useCase, isA<SendResetPasswordEmailUseCase>());
  });

  test('should register and retrieve CheckOtpUseCase', () {
    final useCase = sl<CheckOtpUseCase>();
    expect(useCase, isA<CheckOtpUseCase>());
  });

  test('should register and retrieve RefreshTokenUseCase', () {
    final useCase = sl<RefreshTokenUseCase>();
    expect(useCase, isA<RefreshTokenUseCase>());
  });
  test('should register and retrieve ResetBloc', () {
    final resetBloc = sl<ResetBloc>();
    expect(resetBloc, isA<ResetBloc>());
  });



  test('should register and retrieve AuthBloc', () {
    final authBloc = sl<AuthBloc>();
    expect(authBloc, isA<AuthBloc>());
  });

  test('should register and retrieve SignUpBloc', () {
    final signUpBloc = sl<SignUpBloc>();
    expect(signUpBloc, isA<SignUpBloc>());
  });

  test('should register and retrieve LoginBloc', () {
    final loginBloc = sl<LoginBloc>();
    expect(loginBloc, isA<LoginBloc>());
  });
  test('should register and retrieve Logger', () {
    final logger = sl<Logger>();
    expect(logger, isA<Logger>());
  });
  test('should register and retrieve InternetConnectionChecker', () {
    final checker = sl<InternetConnectionChecker>();
    expect(checker, isA<InternetConnectionChecker>());
  });

  test('should register and retrieve NetworkInfo', () {
    final networkInfo = sl<NetworkInfo>();
    expect(networkInfo, isA<NetworkInfo>());
  });

  test('should register and retrieve FirebaseAuth', () {
    final firebaseAuth = sl<FirebaseAuth>();
    expect(firebaseAuth, isA<FirebaseAuth>());
  });

  test('should register and retrieve FirebaseFirestore', () {
    final firestore = sl<FirebaseFirestore>();
    expect(firestore, isA<FirebaseFirestore>());
  });

  test('should register and retrieve GoogleSignIn', () {
    final googleSignIn = sl<GoogleSignIn>();
    expect(googleSignIn, isA<GoogleSignIn>());
  });

  test('should register and retrieve http.Client', () {
    final httpClient = sl<http.Client>();
    expect(httpClient, isA<http.Client>());
  });

  test('should register and retrieve Store', () {
    final store = sl<Store>();
    expect(store, isA<Store>());
  });
}



class MockAuthRepository extends Mock implements AuthRepo {}
class MockUserAccountRepo extends Mock implements UserAccountRepo {}
class MockUserStatusRepo extends Mock implements UserStatusRepo {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockHttpClient extends Mock implements http.Client {}
void setupAuthTestDependencies() {
  sl.reset();
  sl.registerLazySingleton<AuthRemote>(() => AuthRemoteImpl(sl(), sl(), sl(), sl()));
  sl.registerLazySingleton<UserStatusRemoteDataSource>(() => UserStatusRemoteDataSourceImpl(sl(), sl(), auth: sl()));
  sl.registerLazySingleton<UserAccountDataSource>(() => UserAccountDataSourceImpl(sl(), sl(), sl(), auth: sl()));
  sl.registerLazySingleton<AuthRepo>(() => MockAuthRepository());
  sl.registerLazySingleton<UserAccountRepo>(() => MockUserAccountRepo());
  sl.registerLazySingleton<UserStatusRepo>(() => MockUserStatusRepo());

  // Initialize the use cases
  sl.registerLazySingleton(() => GoogleSignUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithEmailUseCase(sl()));
  sl.registerLazySingleton(() => LoginWithPhoneUseCase(sl()));
  sl.registerLazySingleton(() => RegisterWithEmailUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignUpWithPhoneUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SignOutUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => UpdatePasswordUseCase(userAccountRepo: sl()));
  sl.registerLazySingleton(() => IsNewMemberUseCase(userStatusRepo: sl()));
  sl.registerLazySingleton(() => GetPreviousEmailUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => SendVerifyCodeUseCases(sl()));
  sl.registerLazySingleton(() => SendResetPasswordEmailUseCase(sl()));
  sl.registerLazySingleton(() => CheckOtpUseCase(sl()));
  sl.registerLazySingleton(() => RefreshTokenUseCase(userAccountRepository: sl()));
  // Register BLoCs with mocked dependencies
  sl.registerFactory(() => ResetBloc(sl(), sl(), sl()));

  sl.registerFactory(() => AuthBloc(sl(), refreshTokenUseCase: sl(), signoutUseCase: sl()));
  sl.registerFactory(() => SignUpBloc(signUpUseCase: sl(), sendVerificationEmailUseCase: sl()));
  sl.registerFactory(() => LoginBloc(sl(), sl(), googleSignUseCase: sl()));

  // Registering http.Client and other dependencies
  sl.registerLazySingleton(() => MockHttpClient());
  sl.registerLazySingleton(() => Logger());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Store());
}
