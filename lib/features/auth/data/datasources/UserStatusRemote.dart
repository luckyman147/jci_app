import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jci_app/core/error/Exception.dart';

import '../../../../core/config/services/store.dart';

abstract class UserStatusRemoteDataSource {
  Future< bool> isFirstEntry();
  Future< bool> isLoggedIn();
  Future< bool> isNewMember();
  Future< Unit> updateFirstEntry();
  Future< Unit> updateLoggedIn(bool value);
  Future< Unit> updateTokenFromStorage();
  Future< bool> isEmailVerified();
  Future< bool> isPhoneVerified();
  Future<String> getPreviousEmail();
  Future< Unit> updateUserVerificationStatus();
}
class UserStatusRemoteDataSourceImpl implements UserStatusRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore ;
final Store store;
  UserStatusRemoteDataSourceImpl(this.firestore, this.store, {required this.auth});
  @override
  Future<bool> isEmailVerified() async{
    User? user = auth.currentUser;

    if (user == null) {
     throw NotFoundException();
    }

    await user.reload(); // Refresh user data from Firebase
    user = auth.currentUser; // Reload user information

    return user?.emailVerified ?? false;
  }

  @override
  Future<bool> isFirstEntry() async {
    return !(await store.isFirstEntry());
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = auth.currentUser;

    if (user == null) {
      throw NotFoundException();
    }

    return true;
  }

  @override
  Future<bool> isNewMember() {
    // TODO: implement isNewMember
    throw UnimplementedError();
  }

  @override
  Future<bool> isPhoneVerified() async{
    //DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
    return  false;
  }

  @override
  Future<Unit> updateFirstEntry()async {
    await store.setFirstEntry();
    return Future.value(unit);
  }

  @override
  Future<Unit> updateLoggedIn(bool value)async {
    await store.setLoggedIn(value);
  return Future.value(unit);

  }

  @override
  Future<Unit> updateTokenFromStorage() {
    // TODO: implement updateTokenFromStorage
    throw UnimplementedError();
  }

  @override
  Future<Unit> updateUserVerificationStatus() {
    // TODO: implement updateUserVerificationStatus
    throw UnimplementedError();
  }
  @override
  Future<String> getPreviousEmail() async {
    final email = await store.getPreviousEmail(); // Assuming this is an async call

    if (email != null) {
      return email; // Return the email if it's not null
    } else {
      throw NotFoundException(); // Throw exception if email is null
    }
  }

}