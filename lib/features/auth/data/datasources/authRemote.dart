import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/TeamStore.dart';
import 'package:jci_app/features/auth/data/models/Member/AuthModel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/env/urls.dart';

import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';


import 'package:http/http.dart' as http;

import '../../../../core/error/Failure.dart';

abstract class  AuthRemote {
  Future<bool>  signOut(bool value);

  Future<Either<Failure, MemberModel>> verifyEmail();
  Future<Unit> updatePassword(MemberModel member);
  Future<Unit> refreshToken();
Future<User?> signInWithGoogle();
Future<Unit> RegisterInWithGoogle(MemberModel memberModelGoogleSignUp);

  Future<Unit> SendVerificationEmail(String email,bool isReset);
  Future<Unit> Login(String email,String password);
  Future<Unit> signUp(MemberModel memberModelSignUp);

}
class AuthRemoteImpl implements AuthRemote {
  final Logger logger = Logger();
final http.Client client;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

final FirebaseAuth auth ;
final GoogleSignIn googleSignIn ;
  AuthRemoteImpl(this.auth, this.googleSignIn,  {required this.client});




  @override
  Future<Unit> refreshToken() async {

    final tokens=await Store.GetTokens();

    // replace with your actual access token

    try {
      final Response = await client.post(
        Uri.parse(RefreshTokenUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokens[0]}'

        },

      );

      if (Response.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(Response.body);



        Store.setTokens( response['refreshToken'],response['accessToken'] );
        return Future.value(unit);
      } else {
        // Request failed
      //  print('Request failed with status: ${Response.statusCode}');

        throw ExpiredException();
      }
    } catch (e) {


    throw ServerException();
    }}


  @override
  Future<bool> signOut(value)async {
  final tokens=await Store.GetTokens();






    // replace with your API endpoint
    final  accessToken =  tokens[1]; // replace with your actual access token

    try {
      final Response = await client.post(
        Uri.parse(LogoutUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'refreshToken': '${tokens[0]}', // replace with your actual refresh token
        }),
      );
      if (value){
        await googleSignIn.signOut();
        await auth.signOut();
      }

      if (Response.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(Response.body);
       await  Store.clear();
      await   MemberStore.clearModel();
     await    Store.setLoggedIn(false);
     await TeamStore.clearCache();
        return true;
      } else  if (Response.statusCode == 400 ) {
         return false;
      }
      else {

        await    Store.setLoggedIn(false);

        throw ServerException();
      }
    } catch (e) {
      // Exception occurred during the request

      await    Store.setLoggedIn(false);

      throw UnauthorizedException()  ;




  }}
Future<void> confirmPasswordReset(String oobCode, String newPassword) async {
  try {
    await auth.confirmPasswordReset(
      code: oobCode,
      newPassword: newPassword,
    );
    print('Password reset successfully');
  } catch (e) {
    print('Error confirming password reset: $e');
    rethrow;
  }
}
  @override
  Future<Unit> updatePassword(MemberModel member)async {

  final body=jsonEncode(member.toJson());

    final Response = await client.patch(
      Uri.parse(ForgetPasswordUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (Response.statusCode == 200) {
      final Map<String, dynamic> response = jsonDecode(Response.body);

      return Future.value(unit);
    }
    else if (Response.statusCode==401){
        throw WrongCredentialsException();
    }

    else {

      throw ServerException();
    }
  }

  @override
  Future<Either<Failure, MemberModel>> verifyEmail() {
    // TODO: implement verifyEmail
    throw UnimplementedError();
  }









@override
  Future<Unit> Login(String email,String password) async {



try{

  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  if (userCredential.user?.emailVerified ?? false) {
    // Store tokens
    final idTokenResult = await userCredential.user!.getIdTokenResult();

    await Store.setTokens("",idTokenResult.token!);

    // Fetch role and member information
    DocumentSnapshot userDoc = await _db.collection('users').doc(userCredential.user!.uid).get();
    final user = userDoc.data() as Map<String, dynamic>;
    await MemberStore.saveModel(MemberModel.fromJson(user));
  //  List<String> stringList = (response['Permissions'] as List).map((element) => element.toString()).toList();
   // await Store.setPermissions(stringList);
    await Store.setLoggedIn(true);
    return Future.value(unit);
  }
  else {
    throw UnauthorizedException();
  }
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
 throw NotFoundException();
  } else if (e.code == 'wrong-password') {
    throw WrongCredentialsException();
  }
 else {
     throw ServerException();
  }

  }
  catch (e){
    throw ServerException();
  }
}

@override
Future<Unit> signUp(MemberModel memberModelSignUp)async {
try{
  // Create user with email and password
  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: memberModelSignUp.email,
    password:memberModelSignUp.  password,
  );

  // Get the created user
  User? user = userCredential.user;
  // Update the user profile
  if (user != null) {
    // Prepare user data
    await userCredential.user?.sendEmailVerification();
final userData=memberModelSignUp.toJson();

    // Save user data to Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userData);

    return Future.value(unit);
  }
  throw WrongCredentialsException();
} on FirebaseAuthException catch (e) {
  if (e.code == 'email-already-in-use') {
    throw AlreadyParticipateException();
  }
  throw ServerException();
}


on FirebaseException catch (e) {
  throw Exception('Failed with error code: ${e.code}');
}



catch(e){
throw ServerException();
}


}
Map<String, dynamic> filterMap(Map<String, dynamic> user) {
  return user.containsKey('constraints')  ? user : {};
}

  @override
  Future<Unit> SendVerificationEmail(String email,bool isReset) async {
    try{
    final Response = await client.post(
      Uri.parse(isReset?Urls.ResetPassword: Urls.mailVerify),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email,}),
    );


    final Map<String,dynamic> response  = jsonDecode(Response.body);

    if (Response.statusCode == 200) {
      log(response.toString());
      final  otp = response['otp'];
      log(otp.toString());
      await Store.setOtp(otp.toString());
      return Future.value(unit);
    }
    else if (Response.statusCode == 400) {
      throw WrongCredentialsException();
    }
    else if (Response.statusCode == 404) {
      throw WrongCredentialsException();
    }



    else {
      throw ServerException();
    }
  }
  catch(e){
    log(e.toString());
    throw ServerException();
    }}


Future<void> sendPasswordResetEmail(String email) async {
  try {
    await auth.sendPasswordResetEmail(email: email);
    print('Password reset email sent');
  } catch (e) {
    print('Error sending password reset email: $e');
    rethrow;
  }
}

  @override
  Future<User?> signInWithGoogle() async {
    try {
      logger.i("Starting Google Sign-In process.");

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        logger.i("Google account obtained: ${googleSignInAccount.email}");

        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in with credential
        final UserCredential authResult = await auth.signInWithCredential(credential);
        final User? user = authResult.user;

        logger.i("User signed in: ${user?.email}");

        // Check if user exists in Firestore
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();

        if (userDoc.exists) {
          logger.i("User already exists in Firestore.");
          return user; // User already exists, return the user
        } else {
          logger.i("User does not exist in Firestore, creating new user.");

          // User does not exist, insert new user data into Firestore
          await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
            'displayName': user?.displayName,
            'email': user?.email,

            // Add any other necessary fields here
          });
          return user; // Return the newly created user
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
  Future<Unit> RegisterInWithGoogle(MemberModel memberModelGoogleSignUp)async {

    final body = memberModelGoogleSignUp.toJson();
    //collect user id from firebase
    final User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set(body);
    final idTokenResult = await user.getIdTokenResult();

    await Store.setTokens("",idTokenResult.token!);

    // Fetch role and member information
    DocumentSnapshot userDoc = await _db.collection('users').doc(user.uid).get();
    final users = userDoc.data() as Map<String, dynamic>;
    await MemberStore.saveModel(MemberModel.fromJson(users));
    //  List<String> stringList = (response['Permissions'] as List).map((element) => element.toString()).toList();
    // await Store.setPermissions(stringList);
    await Store.setLoggedIn(true);
    return Future.value(unit);

}


Future<String> getOrCreateRoleId(String roleName) async {
  try {
    // Fetch roles collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('roles')
        .where('name', isEqualTo: roleName)
        .limit(1) // Limit to 1 result for efficiency
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Role exists, return its ID
      return querySnapshot.docs.first.id;
    } else {
      // Role does not exist, create a new role
      DocumentReference newRoleRef = await FirebaseFirestore.instance
          .collection('roles').add({
        'name': roleName,
        "grade": 5,
        "Permissions": [],


        // Add other fields as needed
      });

      // Return the ID of the newly created role
      return newRoleRef.id;
    }
  } catch (e) {
    print('Error fetching or creating role: $e');
    return ''; // Return an empty string or handle error appropriately
  }
}}