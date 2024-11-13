import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:logger/logger.dart';

import '../../../../core/config/services/store.dart';
import '../../../../core/strings/Mails.dart';

abstract class UserAccountDataSource {
  Future<Unit> updatePassword(String email,String password);
  Future<Unit> sendVerificationEmail(String email,String otp);
  Future<Unit> sendResetPasswordEmail(String email);
  Future<Unit> checkOtp(String otp);
  Future<Unit> refreshToken();
  Future<Unit> isTokenExpired();


}
class UserAccountDataSourceImpl implements UserAccountDataSource{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore ;
  final Logger logger ;
  final Store store;

  UserAccountDataSourceImpl(this.firestore, this.logger, this.store, {required this.auth});
  @override
  Future<Unit> checkOtp(String otp) async{
    try {
      String? savedOtp = await store.getOtp();
      if (savedOtp == otp) {
        return Future.value(unit);
      } else {
        throw WrongVerificationException();
      }
    } catch (e) {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> refreshToken()async {
    try {

      User? user = auth.currentUser;

      if (user != null) {
        String? idToken = await user.getIdToken(true);
        String? refreshToken = user.refreshToken;
        //
if (idToken != null) {

  await store.setTokens(refreshToken??"", idToken);
  return Future.value(unit);
}
else{
  throw NotFoundException();
}
      // Return the refreshed token
      } else {
       throw NotFoundException();
      }
    } catch (e) {
  throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> sendResetPasswordEmail(String email)async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return unit;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        logger.e('No user found for that email.');
        throw NotFoundException();
      } else {
        logger.e('Error sending password reset email: $e');
        throw ServerException();
      }
    }
  }

  @override
  Future<Unit> sendVerificationEmail(String email, String otp) async {
    try {
      final language = await store.getLocaleLanguage();
      // Create the email request
      final request = await _createEmailRequest(email, "Your OTP is $otp", "Email Verification",language=="en"? mails.otpMail(otp):mails.otpFrenshMail(otp));
      await _checkDeliveryStatus(request);
      await store.setOtp(otp);

      return unit; // Return Unit
    } catch (e) {
      throw ServerException();
    }
  }

  Future<DocumentReference> _createEmailRequest(String email, String text,String subject,String html) async {
    return await firestore.collection('mail').add({
      'to': [email],
      'message': {
        'text': text,
        'subject': subject,
        'html': html,
      },
    });
  }

  Future<void> _checkDeliveryStatus(DocumentReference request) async {
    // Wait for a few seconds before checking the delivery status
    await Future.delayed(Duration(seconds: 2));

    final value = await request.get();
    final data = value.data() ;
    logger.i('Email delivery status: ${data}');


  }
  @override
  Future<Unit> updatePassword(String email,String password)async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Re-authenticate using the user's current credentials
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password, // Replace with the user's current password
        );
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(password);
        logger.i('Password changed successfully');
        return unit;




      } on FirebaseAuthException catch (e) {
        // Handle Firebase Authentication errors
        if (e.code == 'weak-password') {

          logger.w('The password provided is too weak.');
          throw WrongVerificationException();
        } else if (e.code == 'requires-recent-login') {
          logger.w('The user needs to re-authenticate with a recent login before this operation can be performed.');
throw NotFoundException();

        } else {

          logger.e('Error changing password: ${e.code}');
          throw ServerException();
        }
      } catch (e) {
        logger.e('An unexpected error occurred: $e');
        throw ServerException();
      }
    } else {

      logger.w('No user signed in');throw NotFoundException();
    }
  }

  @override
  Future<Unit> isTokenExpired() async{
    User? user = auth.currentUser;

    if (user == null) {
      throw NotFoundException();
    }

    // Get the IdTokenResult
    IdTokenResult idTokenResult = await user.getIdTokenResult();
    //verfy refresh token is expired



    // Get the expiration time of the token
    DateTime expirationTime = idTokenResult.expirationTime ?? DateTime.now();

    // Compare expiration time with the current time
    bool isExpired = DateTime.now().isAfter(expirationTime);


    if (isExpired) {
      throw ExpiredException();
    }
    return Future.value(unit);
  }

  
}