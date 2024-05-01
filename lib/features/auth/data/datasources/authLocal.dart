import 'package:dartz/dartz.dart';

import '../../../../core/config/services/store.dart';

abstract class AuthLocalDataSources {

  Future<bool> isFirstEntry();
  Future<Unit> updateLoggedIn(bool value);
  Future<Unit> updateTokenFromStorage();
  Future<Unit> updateFirstEntry();
  Future<bool> isLoggedIn();
Future<String> getOtp();
Future<Unit> updateOtp(String otp);

  Future<Unit> refreshToken();
}
class AuthLocalImpl extends AuthLocalDataSources{
  @override
  Future<bool> isFirstEntry()async {

  return !(await Store.isFirstEntry()??false);
  }

  @override
  Future<bool> isLoggedIn()async  {
return (await Store.isLoggedIn()??false);

  }

  @override
  Future<Unit> refreshToken() {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future<Unit> updateFirstEntry()async  {
await Store.setFirstEntry();
return Future.value(unit);

  }

  @override
  Future<Unit> updateLoggedIn(bool value)async {
await Store.setLoggedIn(value);
return Future.value(unit);
  }

  @override
  Future<Unit> updateTokenFromStorage() {
    // TODO: implement updateTokenFromStorage
    throw UnimplementedError();
  }

  @override
  Future<String> getOtp()async  {
  return await Store.getOtp()??'';

  }

  @override
  Future<Unit> updateOtp(String otp)async {
await Store.setOtp(otp);
return Future.value(unit);
  }
}