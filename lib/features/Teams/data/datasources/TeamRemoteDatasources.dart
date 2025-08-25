import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import 'package:jci_app/core/config/env/urls.dart';

import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/features/Teams/data/models/TeamModel.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../core/config/services/store.dart';
import '../../../../../core/config/services/uploadImage.dart';
import '../../../../../core/error/Exception.dart';
import '../../../../core/PrimitiveUser/UserModel.dart';
import '../../domain/entities/TeamUser.dart';

abstract class TeamRemoteDataSource {
  Future<({List<TeamModel> Teams, DocumentSnapshot? lastDoc})> getAllTeams({
      required int limit,
      required bool isPrivate,
      DocumentSnapshot? lastDocument,});
  Future<TeamModel> getTeamById(String id);

  Future<TeamModel> createTeam(TeamModel Team);
  Future<Unit> updateTeam(TeamModel Team);
  Future<Unit> deleteTeam(String id);
  Future<List<TeamModel>> getTeamByName(String name);
  Future<List<TeamModel>> getTeamsOfUser();
  Future<Unit> updateMembers(String teamid, String memberid, String Status);

  Future<Unit> inviteMember(String id, String memberid);
  Future<Unit> kickMember(String id, String memberid);

  Future<Unit> joinTeam(TeamUser user,String id);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final FirebaseFirestore firestore ;
  final Logger logger;
  final Store store;
  final MemberStore memberStore ;
  final FirebaseImageUploader firebaseImageUploader;

  TeamRemoteDataSourceImpl(this.firestore, this.logger, this.store, this.firebaseImageUploader, this.memberStore);
  @override
  Future<TeamModel> createTeam(TeamModel team) async {
    try {
      final teamRef = firestore.collection('teams').doc();
      // Upload cover image if it exists
      final image=await firebaseImageUploader.uploadImagesToFirebase([team.meta.coverImage]);
final teamLeader= await memberStore.getPrimitiveModel();

      final teamWithId = team.copyWith(meta:team.meta.copyWith(id:  teamRef.id,
          coverImage:image[0] ),
         members: team.members.copyWith(teamLeader: teamLeader ));
      logger.i('Team created: ${teamWithId.toJson()}');
      // Set Firestore doc ID
      await teamRef.set(teamWithId.toJson());

      logger.i('Team created: ${teamWithId.toJson()}');
      return teamWithId;
    } on FirebaseException catch (e) {
      logger.e("Firebase error: $e");
      throw ServerException(); // You can customize this
    } catch (e) {
      logger.e("Unknown error: $e");
      throw ServerException();
    }

}

@override
Future<Unit> deleteTeam(String id) async {
  try {
    await firestore.collection('teams').doc(id).delete();
    return unit;
  } on FirebaseException catch (e) {
    logger.e("Failed to delete team: $e");
    throw ServerException();
  } catch (e) {
    logger.e("Unexpected error: $e");
    throw ServerException();
  }
}
  @override
  Future<({List<TeamModel> Teams, DocumentSnapshot? lastDoc})> getAllTeams({
    required int limit,
    required bool isPrivate,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      logger.i("Fetching teams | Limit: $limit | isPrivate: $isPrivate | lastDocument: ${lastDocument?.id}");
      Query query = firestore
          .collection('teams')
          .where('meta.status', isEqualTo: isPrivate ? true : false)

          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
        logger.i("Starting after document: ${lastDocument.id}");
      }

      final snapshot = await query.get();
      logger.i("Fetched ${snapshot.docs.length} team documents");
      final teams = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return TeamModel.fromJson(data);
      }).toList();

      final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      logger.i("Returning ${teams.length} teams. Last doc ID: ${lastDoc?.id}");
      return (Teams: teams, lastDoc: lastDoc);
    } catch (e) {
      logger.e("Error fetching teams: $e");
      throw ServerException();
    }
  }


  @override
  Future<TeamModel> getTeamById(String id) async {
    try {
      final doc = await firestore.collection('teams').doc(id).get();

      if (!doc.exists) {
        throw EmptyDataException(); // Team not found
      }

      final data = doc.data() as Map<String, dynamic>;
      return TeamModel.fromJson(data);
    } on FirebaseException catch (e) {
      logger.e("Firebase error while fetching team by ID: $e");
      throw ServerException();
    } catch (e) {
      logger.e("Unknown error while fetching team: $e");
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateTeam(TeamModel team) async {
    try {
      final teamRef = firestore.collection('teams').doc(team.meta.id);

      // 1. Update team fields (excluding image URL for now)
      await teamRef.update(team.toJson());
      logger.i("Team updated: ${team.toJson()}");

      // 2. Check and update image if it's a local path
      final coverImage = team.meta.coverImage;
      final isLocalPath = coverImage != null &&
          coverImage.isNotEmpty &&
          !(coverImage.startsWith('http://') || coverImage.startsWith('https://'));

      if (isLocalPath) {
        final imageUrl = await firebaseImageUploader.uploadImagesToFirebase([coverImage]);
        if (imageUrl == null) {
          throw ServerException(); // or ImageUploadException
        }

        // Update only the image URL field in Firestore
        await teamRef.update({'CoverImage': imageUrl});
        logger.i("Cover image updated: $imageUrl");
      }

      return unit;
    } on FirebaseException catch (e) {
      logger.e("Firestore update failed: $e");
      throw ServerException();
    } catch (e) {
      logger.e("Unexpected error: $e");
      throw ServerException();
    }
  }


  @override
  Future<List<TeamModel>> getTeamByName(String name) async {
    try {
      final snapshot = await firestore
          .collection('teams')
          .where('name', isEqualTo: name)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // ensure ID is included
        return TeamModel.fromJson(data);
      }).toList();
    } on FirebaseException catch (e) {
      logger.e("Firestore error while searching for team by name: $e");
      throw ServerException();
    } catch (e) {
      logger.e("Unknown error: $e");
      throw ServerException();
    }
  }

  @override
  Future<Unit> inviteMember(String id, String memberid) {
    // TODO: implement inviteMember
    throw UnimplementedError();
  }
  @override
  Future<Unit> joinTeam(TeamUser user, String teamId) async {
    try {
      final teamDocRef = FirebaseFirestore.instance.collection('teams').doc(teamId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final teamSnapshot = await transaction.get(teamDocRef);

        if (!teamSnapshot.exists) {
          throw Exception("Team not found");
        }

        final currentMembers = List<Map<String, dynamic>>.from(
          teamSnapshot.data()?['members']['members'] ?? [],
        );  final currentMembersIds = List<String>.from(
          teamSnapshot.data()?['members']['membersIds'] ?? [],
        );

        // Check if user already exists in the members list
        final alreadyMember = currentMembersIds.any((member) => member== user.user.id);
        if (alreadyMember) {
          Logger( ).e("already exists");
          // Optionally throw or just return early
          return;
        }

        // Add user to members
        currentMembers.add(user.toJson());
        currentMembersIds.add(user.user.id!);

        // Update the members field
        transaction.update(teamDocRef, {'members.members': currentMembers, 'members.membersIds': currentMembersIds});
      });

      return unit;
    } catch (e) {
      // You can also log or handle the error more gracefully
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateMembers(String teamId, String memberid, String newrole) async{
    final teamRef = firestore.collection('teams').doc(teamId);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(teamRef);

      if (!snapshot.exists) {
        throw Exception("Team not found");
      }

      final data = snapshot.data()!;
      final List<dynamic> members = data['members']['members'] ?? [];

      // Find and update the role
      final updatedMembers = members.map((member) {
        if (member['user']['id'] == memberid) {
          return {
            ...member,
            'role':newrole, // store as string
          };
        }
        return member;
      }).toList();

      // Update Firestore
      transaction.update(teamRef, {'members.members': updatedMembers});
      return unit;
    }).catchError((error) {
      throw ServerFailure();
    });
    return unit;
  }



  @override
  Future<List<TeamModel>> getTeamsOfUser() async {
    try {
      final userId = await memberStore.getPrimitiveModel().then((value) => value.id);
      final querySnapshot = await firestore
          .collection('teams')
          .where('members.membersIds', arrayContains: userId)
     .limit(3)     .get();

      final teams = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return TeamModel.fromJson(data); // adapt depending on your model
      }).toList();

      return teams;
    } catch (e) {
      Logger().e("Error fetching teams for user: $e");
      // handle error, log or rethrow
      throw Exception('Failed to get teams for user : $e');
    }
  }

  @override
  Future<Unit> kickMember(String id, String memberid) async{
    final teamRef = firestore.collection('teams').doc(id);

    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(teamRef);

      if (!snapshot.exists) {
        throw Exception("Team not found");
      }

      final data = snapshot.data()!;
      final List<dynamic> members = data['members']['members'] ?? [];
      final List<String> membersIds = List<String>.from(data['members']['membersIds'] ?? []);

      // Remove the member from the list
      final updatedMembers = members.where((member) => member['userId'] != memberid).toList();
      final updatedMembersIds = membersIds.where((memberId) => memberId != memberid).toList();

      // Update Firestore
      transaction.update(teamRef, {'members.members': updatedMembers, 'members.membersIds': updatedMembersIds});
    }).catchError((error) {
      throw ServerFailure();
    });
    return unit;
  }



}
