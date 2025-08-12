import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/MemberSection/data/model/ObjectifsModels.dart';

import '../../../auth/AuthWidgetGlobal.dart';
import '../../domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../domain/entity/ActionDetails.dart';
import '../../presentation/functions/ObjectifCreationService.dart';
import '../Services/ObjectifLogicService.dart';
import '../model/UserObjectifsInfosModel.dart';

abstract class ObjectifDataSource {
  Future<Unit> AddObjectif(ObjectifModel obj);
  Future<Unit> deleteObjectif(String objId);
  Future<Unit> UpdateObjectif(ObjectifModel obj);
  Future<({List<userObjectifsInfosModel> userObjectifInfos, DocumentSnapshot? lastDoc})> fetchUserWithHisObjectifsProgress({required String userId, DocumentSnapshot<Object?>? lastDocument, required int limit});
Future<List<userObjectifsInfosModel>> updateUserProgress(UpdateObjectiveProgressDTO update) ;
  Future<List<userObjectifsInfosModel>> fetchObjectifsInProgress()  ;


}

class ObjectifDataSourcesImpl implements ObjectifDataSource {
  final FirebaseFirestore firestore ;
  final ObjectifService objectiveService;
final Store store;
  ObjectifDataSourcesImpl(this.store, {required this.firestore,required this.objectiveService});

  @override
  Future<Unit> AddObjectif(ObjectifModel obj) async {
    try {
      // Step 1: Create a new document with an auto-generated ID
      DocumentReference docRef = firestore.collection('objectifs').doc();


      // Step 3: Save the updated object to Firestore
      await docRef.set({
        ...obj.toJson(),
        "id": docRef.id, // Ensure id is set when creating the document
      });

      return unit; // Success
    } catch (e) {
      Logger().e(e);
      throw ServerException();
    }
  }

  @override
  Future<Unit> UpdateObjectif(ObjectifModel obj) async {
    try {
      // Update the Objectif in the 'objectifs' collection
      await firestore.collection('objectifs').doc(obj.id).update(obj.toJson());
      return unit; // Success
    } catch (e) {
      throw Exception('Failed to update Objectif: $e');
    }
  }
  @override
  Future<Unit> deleteObjectif(String objId) async {
    try {
      // Get all users
      final usersSnapshot = await firestore.collection('users').get();

      // Iterate through users and delete the objectif from each user's 'line_objectifs'
      for (var userDoc in usersSnapshot.docs) {
        await firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('line_objectifs')
            .doc(objId)
            .delete()
            .catchError((e) {
        throw ServerException();
        });
      }

      // Delete the Objectif from the 'objectifs' collection
      await firestore.collection('objectifs').doc(objId).delete();

      return unit; // Success
    } catch (e) {
      throw Exception('Failed to delete Objectif: $e');
    }
  }

  @override
  Future<({List<userObjectifsInfosModel> userObjectifInfos, DocumentSnapshot? lastDoc})> fetchUserWithHisObjectifsProgress(
      {required String userId, DocumentSnapshot<Object?>? lastDocument, required int limit}) async{
    try {
      // Get the line_objectifs subcollection of the user
      CollectionReference userLineObjectifsRef = firestore
          .collection("users")
          .doc(userId)
          .collection("line_objectifs");
      Query query = userLineObjectifsRef.orderBy("assignedAt").limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot querySnapshot = await query.get();
      if (querySnapshot.docs.isEmpty) {
        return (userObjectifInfos: <userObjectifsInfosModel>[], lastDoc: null);
      }

      // Get objectif IDs from line_objectifs subcollection
      List<String> objectifIds = querySnapshot.docs
          .map((doc) => doc['objectifId'] as String)
          .toList();

      List<userObjectifsInfosModel> userObjectifInfos = [];

      // Fetch objectives using the fetched IDs
      for (var objectifId in objectifIds) {
        DocumentSnapshot objectifDoc = await firestore
            .collection("objectifs")
            .doc(objectifId)
            .get();

        if (objectifDoc.exists) {
          // Assuming your objectif document structure is as needed
          final objectifData = objectifDoc.data();
          var objectif = ObjectifModel.fromJson(objectifData as Map<String,dynamic>);

          // Get user_objectif from the line_objectifs collection
          var userObjectif = querySnapshot.docs
              .firstWhere((doc) => doc['objectifId'] == objectifId);

          //convert to UserObjectif

          var userObjectifModel = UserObjectifsModel.fromJson(userObjectif.data() as Map<String, dynamic>);


          // Add both objectif and userObjectif to the list
          userObjectifInfos.add(
            userObjectifsInfosModel(objectif: objectif, userObjectif: userObjectifModel),
          );
        }
      }


      return (userObjectifInfos: userObjectifInfos, lastDoc: querySnapshot.docs.last);
    } catch (e) {
      Logger().e(e);
      throw ServerException();
    }
  }

  @override
  Future<List<userObjectifsInfosModel>> updateUserProgress(UpdateObjectiveProgressDTO updateDto)async {
      return await objectiveService.updateUserObjectiveProgress(updateDto: updateDto);

  }
  @override
  Future<List<userObjectifsInfosModel>> fetchObjectifsInProgress() async {

    try {
      final userId=store .getUserId() ;
      final querySnapshot = await firestore
          .collection("users")
          .doc(userId)
          .collection("line_objectifs")
          .where("isCompleted", isEqualTo: false)
          .where("currentProgress", isGreaterThanOrEqualTo: 0)
          .orderBy('currentProgress', descending: true)
          .get();

      if (querySnapshot.docs.isEmpty) return [];

      List<String> objectifIds = querySnapshot.docs
          .map((doc) => doc['objectifId'] as String)
          .toList();

      List<userObjectifsInfosModel> allUserObjectifInfos = [];

      for (var objectifId in objectifIds) {
        final objectifDoc = await firestore.collection("objectifs").doc(objectifId).get();

        if (!objectifDoc.exists) continue;

        final objectifData = objectifDoc.data() as Map<String, dynamic>;
        final objectif = ObjectifModel.fromJson(objectifData);

        final userObjectifDoc = querySnapshot.docs.firstWhere((doc) => doc['objectifId'] == objectifId);

        final userObjectif = UserObjectifsModel.fromJson(
          userObjectifDoc.data() as Map<String, dynamic>,
        );

        allUserObjectifInfos.add(userObjectifsInfosModel(objectif: objectif, userObjectif: userObjectif));
      }

// Now filter to 3 unique groupObjectif
      List<userObjectifsInfosModel> uniqueGroupObjectifs = [];
      Set<GroupObjectif> seenGroups = {};

      for (var info in allUserObjectifInfos) {
        final group = info.objectif.groupObjectif; // assuming this field exists on ObjectifModel

        if (!seenGroups.contains(group)) {
          uniqueGroupObjectifs.add(info);
          seenGroups.add(group);
        }

        if (uniqueGroupObjectifs.length == 3) break;
      }

      return uniqueGroupObjectifs;

    } catch (e) {
      Logger().e(e);
      throw ServerException();
    }
  }

}
