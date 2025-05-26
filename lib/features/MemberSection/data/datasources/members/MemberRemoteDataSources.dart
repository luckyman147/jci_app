import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../core/PrimitiveUser/UserModel.dart';
import '../../../../../core/config/services/store.dart';
import '../../../../../core/config/services/uploadImage.dart';
import '../../../../../core/error/Exception.dart';
import '../../../../../core/MemberModel.dart';

import 'package:http/http.dart' as http;

abstract class MemberRemote {
  Future<MemberModel> getUserProfile();
  Future<List<MemberModel>> GetmMemberByName(String name);
  Future<List<UserModel>> GetMembers();
  Future<MemberModel> getMemberByid(String id);
  Future<Unit> UpdateMemberProfile(MemberModel memberModel);
  Future<Unit> ChangeLanguage(String language);
  Future<MemberModel> getMemberWithHightRank();
  Future<List<MemberModel>> getMembersWithRanks();
}

class MemberRemoteImpl implements MemberRemote {
  final FirebaseFirestore fire;
  final MemberStore memberStore;
  final Logger logger;
  final Store store;
  final FirebaseImageUploader firebaseImageUploader;

  MemberRemoteImpl(this.memberStore,
      {required this.fire,
      required this.logger,
      required this.store,
      required this.firebaseImageUploader});

  @override
  Future<List<MemberModel>> getMembersWithRanks() async {
    try {
      final query = await fire
          .collection('users')
          .orderBy('rank', descending: true)
          .get();

      return await Future.wait(query.docs.map((doc) async {
        final roleRef = doc['role'] as DocumentReference?;
        Map<String, dynamic>? roleData;

        if (roleRef != null) {
          roleData = (await roleRef.get()).data() as Map<String, dynamic>?;
        }

        return MemberModel.fromJson(doc.data()!)
            .fromrole(roleData?['roleName'] ?? '');
      }));
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw UnauthorizedException();
      throw ServerException();
    }
  }

  @override
  Future<MemberModel> getMemberWithHightRank() async {
    try {
      final query = await fire
          .collection('users')
          .orderBy('rank', descending: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) throw EmptyDataException();

      final doc = query.docs.first;
      final roleRef = doc['role'] as DocumentReference?;
      Map<String, dynamic>? roleData;

      if (roleRef != null) {
        roleData = (await roleRef.get()).data() as Map<String, dynamic>?;
      }

      return MemberModel.fromJson(doc.data())
          .fromrole(roleData?['roleName'] ?? '');
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') throw UnauthorizedException();
      throw ServerException();
    }
  }

  @override
  Future<MemberModel> getUserProfile() async {
    try {
      final userId = await store.getUserId();
      // Reference to the Firestore collection
      final collectionRef = fire.collection('users');

      // Fetch the specific document by ID
      final docSnapshot = await collectionRef.doc(userId).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        final roleReference = docSnapshot['role'] as DocumentReference?;
        Map<String, dynamic>? roleData;
        if (roleReference != null) {
          final roleSnapshot = await roleReference.get();
          if (roleSnapshot.exists) {
            roleData = roleSnapshot.data() as Map<String, dynamic>?;
          }
        }
logger.i(docSnapshot.data());
        // Convert the document to a UserModel
        return MemberModel.fromJson(
          docSnapshot.data()!,
        ).fromrole(roleData!["roleName"]);
      } else {
        // Throw an exception if the user is not found
        throw Exception('User not found');
      }
    } catch (e) {
      // Log and throw custom exceptions for error handling
      Logger().e('Exception during Firestore fetch: $e');
      throw ServerException(); // Replace with your custom exception
    }
  }

  @override
  Future<List<MemberModel>> GetmMemberByName(String name) async {
    try {
      // Reference to the Firestore collection
      final collectionRef = FirebaseFirestore.instance.collection('users');

      // Convert the name to lowercase for case-insensitive search
      final lowerCaseName = name.toLowerCase();

      // Query for `firstName` starting with the input
      final firstNameSnapshot = await collectionRef
          .where("firstName", isGreaterThanOrEqualTo: lowerCaseName)
          .where("firstName", isLessThan: '$lowerCaseName\uf8ff')
          .get();

      // Query for `lastName` starting with the input
      final lastNameSnapshot = await collectionRef
          .where("lastName", isGreaterThanOrEqualTo: lowerCaseName)
          .where("lastName", isLessThan: '$lowerCaseName\uf8ff')
          .get();

      // Combine results from both queries
      final combinedDocs = {
        ...firstNameSnapshot.docs,
        ...lastNameSnapshot.docs
      };

      // Map the documents to `MemberModel`
      final memberModels =
          combinedDocs.map((doc) => MemberModel.fromJson(doc.data())).toList();

      return memberModels;
    } catch (e) {
      // Log and throw custom exceptions for error handling
      Logger().e('Exception during Firestore fetch: $e');
      throw ServerException(); // Replace with your custom exception
    }
  }

  @override
  Future<List<UserModel>> GetMembers() async {
    try {
      // Get the current user ID (replace this with your logic to get the model's ID)

      // Reference to the Firestore collection
      final collectionRef = FirebaseFirestore.instance.collection('users');

      // Fetch the documents
      final querySnapshot = await collectionRef.get();

      // Convert the documents to a list of `MemberModel`
      final memberModels = querySnapshot.docs
          .map<UserModel>((doc) => UserModel.fromJson(doc.data(), false))
          .toList();

      return memberModels;
    } catch (e) {
      // Log and throw custom exceptions for error handling
      Logger().e('Exception during Firestore fetch: $e');
      throw ServerException(); // Replace with your custom exception
    }
  }

  @override
  Future<Unit> UpdateMemberProfile(MemberModel memberModel) async {
    try {
      // 1. Get Firestore reference for the member document
      final memberRef = fire.collection('users').doc(memberModel.id);

      // 2. Prepare update data (exclude non-updatable fields if needed)
      final updateData = memberModel.toJson()
        ..remove('id') // Remove fields that shouldn't be updated
        ..remove('createdAt');

      // 3. Update the document in Firestore
      await memberRef.update(updateData);

      // 4. Handle image upload if exists
      if (memberModel.Images.isNotEmpty) {
        final imageUrl = await firebaseImageUploader
            .uploadImagesToFirebase(memberModel.Images as List<String>);

        // Update the image URL in Firestore
        await memberRef.update({'Images': imageUrl});

        // Update local model with new URL
        final updatedMember = memberModel.copyWith(Images: imageUrl);
        await memberStore.saveModel(updatedMember);
      } else {
        // Just save the model without image update
        await memberStore.saveModel(memberModel);
      }

      return unit;
    } on FirebaseException catch (e) {
      logger.e('Firestore update error: ${e.message}');
      throw _handleFirestoreError(e);
    } catch (e) {
      logger.e('Unexpected error updating member: $e');
      throw ServerException();
    }
  }

  Exception _handleFirestoreError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return UnauthorizedException();
      case 'not-found':
        return WrongCredentialsException();
      case 'invalid-argument':
        return EmptyDataException();
      default:
        return ServerException();
    }
  }

  @override
  Future<MemberModel> getMemberByid(String id) async {
    try {
      // Get the member document from Firestore
      final memberDoc = await fire.collection('users').doc(id).get();

      if (!memberDoc.exists) {
        throw WrongCredentialsException(); // Member not found
      }

      // Get role data if role reference exists
      Map<String, dynamic>? roleData;
      final roleRef = memberDoc['role'] as DocumentReference?;
      if (roleRef != null) {
        final roleDoc = await roleRef.get();
        roleData = roleDoc.data() as Map<String, dynamic>?;
      }

      // Convert to MemberModel
      return MemberModel.fromJson(memberDoc.data()!)
          .fromrole(roleData?['roleName'] ?? '');
    } on FirebaseException catch (e) {
      // Handle specific Firestore errors
      if (e.code == 'permission-denied') {
        throw UnauthorizedException();
      }
      logger.e(e.toString());
      throw NotFoundException();
    } catch (e) {
      logger.e(e.toString());

      throw ServerException();
    }
  }

  @override
  Future<Unit> ChangeLanguage(String language) async {
    try {
      final userId = await store.getUserId();

      // Update language field in Firestore
      await fire.collection('users').doc(userId).update({
        'language': language,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return unit;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw UnauthorizedException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}
