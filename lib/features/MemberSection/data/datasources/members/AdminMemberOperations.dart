import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/MemberModel.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../core/config/services/store.dart';

abstract class AdminMemberOperations {

  Future<Unit> deleteAccount();
  Future<Unit> UpdatePoints(String memberid, double cotisation);
  Future<Unit> validateMember(String memberid);

  Future<Unit> validateCotisation(String memberid, int type, bool cotisation);


  Future<Unit> deleteMember(String id);
}

class AdminMemberOperationsImpl implements AdminMemberOperations{
final FirebaseFirestore fire;
final Store store;
  AdminMemberOperationsImpl(this.store, {required this.fire});
@override
Future<Unit> UpdatePoints(String memberid, double points) async {
  try {
    // Run in transaction to ensure atomic operation
    await fire.runTransaction((transaction) async {
      // Get current document
      final docRef = fire.collection('users').doc(memberid);
      final doc = await transaction.get(docRef);

      if (!doc.exists) {
        throw WrongCredentialsException();
      }

      // Get current points
      final currentPoints = (doc['points'] );

      // Update with new values
      transaction.update(docRef, {
        'points': points,
        'PreviousPoints': currentPoints, // Set to value before increment
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });

    return unit;
  } on FirebaseException catch (e) {
    if (e.code == 'permission-denied') throw UnauthorizedException();
    throw ServerException();
  }
}

  @override
  Future<Unit> deleteAccount() async {
    try {
      final userId = await store.getUserId();
      await fire.collection('users').doc(userId).delete();
      return unit;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw UnauthorizedException();
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteMember(String id) async {
    try {
      await fire.collection('users').doc(id).delete();
      return unit;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw UnauthorizedException();
      if (e.code == 'not-found') throw WrongCredentialsException();
      throw ServerException();
    }
  }


  @override
  Future<Unit> validateCotisation(String memberid, int index, bool cotisation) async { try {
    DocumentSnapshot snapshot = await fire.collection('users').doc(memberid).get();
    if (snapshot.exists) {
      // Get the current list or initialize an empty list if null
      List<dynamic> cotisationList = (snapshot.data() as Map?)?["cotisation"] as List<dynamic>? ?? [];

      Logger().i("Original cotisation list: $cotisationList");

      // Handle case where list is too short or empty
      if (index >= 0) {
        // If index is beyond current list length, pad with false values
        while (cotisationList.length <= index) {
          cotisationList.add(false);
        }

        // Update the value at specified index
        cotisationList[index] = cotisation;

        // Update Firestore document
        await fire.collection('users').doc(memberid).update({
          'cotisation': cotisationList,
        });

        Logger().i("Updated cotisation list: $cotisationList");
      } else {
        Logger().e('Invalid index: $index');
        return Future.error('Invalid index: $index');
      }
    } else {
      // Handle case where document doesn't exist
      if (index >= 0) {
        // Create new list with the single value at index
        List<bool> newList = List.filled(index + 1, false);
        newList[index] = cotisation;

        await fire.collection('users').doc(memberid).set({
          'cotisation': newList,
        }, SetOptions(merge: true));

        Logger().i("Created new cotisation list: $newList");
      } else {
        Logger().e('Invalid index: $index');
        return Future.error('Invalid index: $index');
      }
    }
    return Future.value(unit);
  } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw UnauthorizedException();
      throw ServerException();
    }
  }

  @override
  Future<Unit> validateMember(String memberid) async {
    try {
      await fire.collection('users').doc(memberid).update({
        'is_validated': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return unit;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw UnauthorizedException();
      throw ServerException();
    }
  }



}