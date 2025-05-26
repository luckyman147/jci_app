import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../../../../core/error/Exception.dart';
import '../../../auth/AuthWidgetGlobal.dart';
import '../../domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../domain/entity/Objectif.dart';
import '../model/ObjectifsModels.dart';
import '../model/UserObjectifsInfosModel.dart';

class ObjectifService {
  final FirebaseFirestore firestore;
  final Logger logger;
  final Store store;

  ObjectifService(this.store, {required this.firestore, required this.logger});

  /// Updates the user's progress for their objectives based on action type, feature, and role.
  ///
  /// This function fetches the user's role, their incomplete objectives, and the corresponding
  /// target objectives to update their progress. It performs all updates in a batch operation
  /// to optimize Firestore writes.
  ///
  /// - [updateDto] - A DTO containing the userId, actionType, feature, and progress increment.
  ///
  /// Returns a list of updated `userObjectifsInfosModel` objects containing both the objective
  /// and the updated user objective data.
  Future<List<userObjectifsInfosModel>> updateUserObjectiveProgress({
    required UpdateObjectiveProgressDTO updateDto,
  }) async {
    try {
      logger.d(
          "Starting updateUserObjectiveProgress for user: ${updateDto.userId}");

      // Step 1: Fetch the user's role document.
      DocumentSnapshot userDoc = await _fetchUserDocument(updateDto.userId);
      logger.d("User document fetched for user: ${updateDto.userId}");

      DocumentReference roleRef = _getUserRoleReference(userDoc);
      logger.d("User role reference fetched");

      // Step 2: Fetch the role document using the reference.
      DocumentSnapshot roleDoc = await _fetchRoleDocument(roleRef);
      String userRoleCategory = _extractRoleCategory(roleDoc);
      logger.d("User role category extracted: $userRoleCategory");

      // Step 3: Fetch the user's incomplete objectives.
      QuerySnapshot querySnapshot =
          await _fetchIncompleteUserObjectives(updateDto.userId);
      logger.d("Fetched ${querySnapshot.docs.length} incomplete objectives");

      if (querySnapshot.docs.isEmpty) {
        logger.d("No incomplete objectives found.");
        return []; // No objectives to update.
      }

      // Step 4: Fetch all related objectives in parallel.
      List<String> objectifIds =
          querySnapshot.docs.map((doc) => doc['objectifId'] as String).toList();
      logger.d("Objective IDs to update: $objectifIds");

      var objectifDocs = await _fetchObjectivesByIds(objectifIds);
      logger.d("Fetched ${objectifDocs.length} objective documents ");

      // Step 5: Prepare to batch update Firestore.
      WriteBatch batch = firestore.batch();
      List<userObjectifsInfosModel> updatedUserObjectifsInfos = [];

      // Step 6: Process each incomplete user objective.
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        var userLineDoc = querySnapshot.docs[i];
        var userObjectifModel = UserObjectifsModel.fromJson(
            userLineDoc.data() as Map<String, dynamic>);

        var objectifDoc = objectifDocs[i];
        if (objectifDoc.exists) {
          var objectif = ObjectifModel.fromJson(
              objectifDoc.data() as Map<String, dynamic>);

          // Step 7: Check if the objective matches the user's role, action type, and feature.
          if (_matchesObjectiveCible(objectif, userRoleCategory,
              updateDto.actionType, updateDto.feature)) {
            logger.d("Objective ${objectif.id} matches criteria");

            // Step 8: Update the user's progress.
            var updatedUserObjective = _updateUserProgress(
                userObjectifModel, updateDto.progress, objectif);
            logger.d(
                "Updated progress for objective ${objectif.id}: ${updatedUserObjective.currentProgress}, completed: ${updatedUserObjective.isCompleted}");

            // Step 9: Add to batch update.
            batch.update(
              firestore
                  .collection("users")
                  .doc(updateDto.userId)
                  .collection("line_objectifs")
                  .doc(userLineDoc.id),
              {
                'currentProgress': updatedUserObjective.currentProgress,
                'isCompleted': updatedUserObjective.isCompleted,
              },
            );
            // step user points if updatedUserObjective.isCompleted ==true
// Step 10: Increment user points if the objective is completed.
            if (updatedUserObjective.isCompleted == true) {
              batch.update(
                firestore.collection("users").doc(updateDto.userId),
                {
                  'points': FieldValue.increment(objectif
                      .points), // Assuming `points` is the field storing user points.
                },
              );
            }
            if (await store.getUserId() == updateDto.userId) {
              // Add the updated objective info to the result list.
              updatedUserObjectifsInfos.add(
                userObjectifsInfosModel(
                    objectif: objectif, userObjectif: updatedUserObjective),
              );
            }
          } else {
            logger.d("Objective ${objectif.id} does not match criteria");
          }
        } else {
          logger.d(
              "Objective document for ID ${querySnapshot.docs[i]['objectifId']} does not exist");
        }
      }

      // Step 10: Commit the batch to Firestore.
      await batch.commit();
      logger.d("Batch commit successful");

      // Return the updated objectives info list.
      return updatedUserObjectifsInfos;
    } catch (e) {
      logger.e("Error in updateUserObjectiveProgress: $e");
      throw ServerException(); // Handle any errors.
    }
  }

  /// Fetches the user document from Firestore by user ID.
  Future<DocumentSnapshot> _fetchUserDocument(String userId) async {
    DocumentSnapshot userDoc =
        await firestore.collection("users").doc(userId).get();
    if (!userDoc.exists) {
      throw Exception("User not found");
    }
    return userDoc;
  }

  /// Extracts the role reference from the user's document.
  DocumentReference _getUserRoleReference(DocumentSnapshot userDoc) {
    var roleRef =
        (userDoc.data() as Map<String, dynamic>)["role"] as DocumentReference?;
    if (roleRef == null) {
      throw Exception("Role reference is not found");
    }
    return roleRef;
  }

  /// Fetches the role document from Firestore using the role reference.
  Future<DocumentSnapshot> _fetchRoleDocument(DocumentReference roleRef) async {
    DocumentSnapshot roleDoc = await roleRef.get();
    if (!roleDoc.exists) {
      throw Exception("Role not found");
    }
    return roleDoc;
  }

  /// Extracts the role name or identifier from the role document.
  String _extractRoleCategory(DocumentSnapshot roleDoc) {
    String userRoleCategory =
        (roleDoc.data() as Map<String, dynamic>)['RoleCategory'] ?? '';
    return userRoleCategory;
  }

  /// Fetches the user's incomplete objectives from Firestore.
  Future<QuerySnapshot> _fetchIncompleteUserObjectives(String userId) async {
    CollectionReference userLineObjectifsRef =
        firestore.collection("users").doc(userId).collection("line_objectifs");
    Query query = userLineObjectifsRef.where("isCompleted", isEqualTo: false);
    return await query.get();
  }

  /// Fetches multiple objectives by their IDs in parallel.
  Future<List<DocumentSnapshot>> _fetchObjectivesByIds(
      List<String> objectifIds) async {
    return await Future.wait(objectifIds
        .map((id) => firestore.collection("objectifs").doc(id).get()));
  }

  /// Checks if the objectif matches the user's role, action type, and feature.
  bool _matchesObjectiveCible(Objectif objectif, String userRole,
      String actionType, List<String> features) {
    Logger().w(objectif.feature.name);
    Logger().w(userRole);
    Logger().w(actionType);
    Logger().w(features);

    return objectif.cible.any((cible) => cible.name == userRole) &&
        objectif.objectifActionType.name == actionType &&
        features.any((feature) => feature == objectif.feature.name);
  }

  /// Updates the user's progress for the objectif and marks it as completed if the target is reached.
  ///
  /// Returns a new instance of [UserObjectifsModel] with the updated progress and completion status.
  UserObjectifsModel _updateUserProgress(
      UserObjectifsModel userObjectifModel, int progress, Objectif objectif) {
    // Calculate the updated progress.
    final int current = userObjectifModel.currentProgress ?? 0;
    final int updatedProgress =
        (current + progress) < 0 ? 0 : (current + progress);

    final bool isCompleted = updatedProgress >= (objectif.target ?? 0);

    // Return a new instance with updated values.
    return userObjectifModel.copyWith(
      progress: updatedProgress,
      completed: isCompleted,
    );
  }
}
