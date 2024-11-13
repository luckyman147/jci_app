import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jci_app/features/auth/data/models/Member/AuthUserModel.dart';
import 'package:jci_app/features/auth/domain/dtos/LoginWithEmailDto.dart';
import 'package:jci_app/features/auth/domain/dtos/LoginWithPhoneDto.dart';
import 'package:jci_app/features/auth/domain/dtos/SignInDtos.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/TeamStore.dart';
import 'package:jci_app/core/MemberModel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';



abstract class  AuthRemote {
  Future<Unit>  signOut(bool value);

Future<Unit> signInWithGoogle();




  Future<Unit>  RegisterWithEmail(SignInDtos signin) ;

  Future<Unit>  RegisterWithPhone(SignInDtos signin) ;

  Future<Unit> logInWithEmail(LoginWithEmailDtos login) ;

  Future<Unit> logInWithPhone(LoginWithPhoneDtos login) ;

}
class AuthRemoteImpl implements AuthRemote {
  final Logger logger ;

  final FirebaseFirestore db = FirebaseFirestore.instance;

  final FirebaseAuth auth;
  final Store store;

  final GoogleSignIn googleSignIn;

  AuthRemoteImpl(this.auth, this.googleSignIn, this.logger, this.store, );

  @override
  Future<Unit> signOut(bool value) async {
    try {
      if (value) {
        await googleSignIn.signOut();
      }

        await auth.signOut();


      await store.clear();
      await MemberStore.clearModel();
      await store.setLoggedIn(false);
      await TeamStore.clearCache();
      return Future.value(unit);
    } catch (e) {
      await store.setLoggedIn(false);
      throw AlreadyLogoutException();
    }
  }




  Map<String, dynamic> filterMap(Map<String, dynamic> user) {
    return user.containsKey('constraints') ? user : {};
  }

  @override
  Future<Unit> signInWithGoogle() async {
    try {
      await googleSignIn.signOut();

      logger.i("Starting Google Sign-In process.");


      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        logger.i("Google account obtained: ${googleSignInAccount.email}");

        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        logger.i("Google account obtained: ${googleSignInAuthentication.accessToken}");

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        logger.i("Google account obtained: ${googleSignInAccount.email}");

        // Sign in with credential
        final UserCredential authResult = await auth.signInWithCredential(
            credential);
        final User? user = authResult.user;

        logger.i("User signed in: ${user?.email}");

        // Check if user exists in Firestore
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users').doc(user?.uid).get();

        if (userDoc.exists) {
          logger.i("User already exists in Firestore.");
         await SaveInCache(db, user!);
          return Future.value(unit); // User already exists, return the user
        } else {
          logger.i("User does not exist in Firestore, creating new user.");
          await RegisterInWithGoogle(db);
          await SaveInCache(db, user!);
          return Future.value(unit); // Return the newly created user
        }
      } else {
        logger.e("Google Sign-In was unsuccessful.");
        throw ServerException();
      }
    } catch (e) {
      await googleSignIn.signOut();
      await auth.signOut();
      logger.e("Error during Google Sign-In: $e");
      throw ServerException(); // Rethrow the error after logging it
    }
  }


  @override
  Future<Unit>   RegisterWithEmail(SignInDtos signin)async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: signin.member!.email.trim(),
        password: signin.member!.password.trim(),
      );


        final authuser=AuthUserModel.fromEntity(signin.member!);
        await RegisterInUSer(authuser, db);

        return Future.value(unit);



    }   on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
    throw AlreadyParticipateException();
    }

    else {
    throw ServerException();
    }
    }  catch (e) {
      throw ServerException();
    }
  }

  @override
  RegisterWithPhone(SignInDtos signin) {
    // TODO: implement RegisterWithPhone
    throw UnimplementedError();
  }

  @override
  Future <Unit> logInWithEmail(LoginWithEmailDtos login) async {

    try {
      logger.i("Logging in with email and password."
      ,login.email

      );
      logger.i("Logging in with email and password."
          ,login.password
      );

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: login.email,
        password: login.password,
      );

      logger.i("mmmm in with email and password."
          ,login.password
      );


     await SaveInCache(db, userCredential.user!);
      logger.i("mmmm in with email and password."
          ,login.password
      );

        return Future.value(unit);


    }   on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
    throw NotFoundException();
    }
    else if (e.code == 'wrong-password') {
    throw WrongVerificationException();
    }
    else {
      logger.e("Error during email login: $e");
    throw e ;
    }


    }  catch (e) {
      throw ServerException();
    }
  }


  @override
  Future<Unit> logInWithPhone(LoginWithPhoneDtos login) async {
    return Future.value(unit);
  }


  Future<Unit> RegisterInUSer(AuthUserModel memberModelGoogleSignUp,
      FirebaseFirestore db) async {
    final body = memberModelGoogleSignUp.toJson();
    //collect user id from firebase
    final User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(
        body);



    return Future.value(unit);
  }
  Future<void> SaveInCache(FirebaseFirestore db, User user) async {
    final logger = Logger(); // Create a logger instance

    logger.i('Start saving user to cache'); // Log the beginning of the function

    DocumentSnapshot userDoc = await db.collection('users').doc(user.uid).get();




    final idTokenResult = await user.getIdToken();
await store.SetEmail(user.email!);
    await store.setTokens("", idTokenResult!);

    await store.setLoggedIn(true);
  // Log setting logged in flag
  }
  Future <void> RegisterInWithGoogle(
      FirebaseFirestore db) async {
    final User? user = FirebaseAuth.instance.currentUser;
    logger.i("User signed in: ${user?.email}");
    final language = await store.getLocaleLanguage();

    final UserGoogle=AuthUserModel.ofGoogle(email: user!.email!, displayName: user!.displayName!, language: language!, photoUrl: user.photoURL!, role:await getRoleReferenceByName("Member"),);



    final body = UserGoogle.toJson();
    //collect user id from firebase
    logger.i("User sqs in: ${body}");


    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        body);


}
  Future<DocumentReference?> getRoleReferenceByName(String roleName) async {
    // Query the roles collection to find the document with the specified roleName
    final querySnapshot = await FirebaseFirestore.instance
        .collection("roles")
        .where("roleName", isEqualTo: roleName)
        .limit(1)  // Limit to 1 since roleName is expected to be unique
        .get();

    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      // Return the DocumentReference of the found role
      return querySnapshot.docs.first.reference;
    } else {
      // No document found with the specified roleName
      return null;
    }
  }
}
