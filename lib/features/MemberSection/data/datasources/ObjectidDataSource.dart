import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/MemberSection/data/model/ObjectifsModels.dart';

import '../../../auth/AuthWidgetGlobal.dart';
import '../model/UserObjectifsInfosModel.dart';

abstract class ObjectifDataSource {
  Future<Unit> AddObjectif(ObjectifModel obj);
  Future<Unit> deleteObjectif(String objId);
  Future<Unit> UpdateObjectif(ObjectifModel obj);
  Future<({List<userObjectifsInfosModel> userObjectifInfos, DocumentSnapshot? lastDoc})> fetchUserWithHisObjectifsProgress({required String userId, DocumentSnapshot<Object?>? lastDocument, required int limit});
}

class ObjectifDataSourcesImpl implements ObjectifDataSource {
  final FirebaseFirestore firestore ;

  ObjectifDataSourcesImpl({required this.firestore});

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

}