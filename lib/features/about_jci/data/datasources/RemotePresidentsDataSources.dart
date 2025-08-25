import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/about_jci/data/models/PresidentModel.dart';
import '../../../../core/error/Exception.dart';

abstract class RemotePresidentsDataSources {

  Future<(List<PresidentModel>, DocumentSnapshot?)> getPresidents(
      int limit, {
        DocumentSnapshot? lastDocument,
      });
        Future<PresidentModel> createPresident(PresidentModel president);
  Future<Unit> deletePresident(String id);
  Future<PresidentModel> updatePresident(PresidentModel president);
  Future<PresidentModel> updateImagePresident(String id, String imageUrl);
}

class RemotePresidentsDataSourcesImpl implements RemotePresidentsDataSources {
  final FirebaseFirestore firestore;

  RemotePresidentsDataSourcesImpl({required this.firestore});

  CollectionReference get _presidentsCollection =>
      firestore.collection('presidents');
  @override
  Future<PresidentModel> createPresident(PresidentModel president) async {
    try {
      // Add new president (without id first)
      final docRef = await _presidentsCollection.add(president.toJson());

      // Update the same doc with its generated id
      await docRef.update({"id": docRef.id});

      // Fetch the updated document
      final newDoc = await docRef.get();

      return PresidentModel.fromJson(newDoc.data() as Map<String, dynamic>)
          .copyWith(id: newDoc.id);
    } catch (e) {
      throw ServerException();
    }
  }


  @override
  Future<Unit> deletePresident(String id) async {
    try {
      await _presidentsCollection.doc(id).delete();
      return unit;
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<(List<PresidentModel>, DocumentSnapshot?)> getPresidents(
      int limit, {
        DocumentSnapshot? lastDocument,
      }) async {
    try {
      Query query = _presidentsCollection
          .orderBy("year", descending: true)
          .limit(limit);

      // Apply pagination if lastDocument exists
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      final presidents = querySnapshot.docs
          .map((doc) => PresidentModel.fromJson(doc.data() as Map<String, dynamic>)
          .copyWith(id: doc.id))
          .toList();

      // Get the last document of this page (for next pagination call)
      final newLastDocument =
      querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      return (presidents, newLastDocument);
    } catch (e) {
      throw ServerException();
    }
  }


  @override
  Future<PresidentModel> updatePresident(PresidentModel president) async {
    try {
      await _presidentsCollection.doc(president.id).update(president.toJson());
      final updatedDoc =
      await _presidentsCollection.doc(president.id).get();
      return PresidentModel.fromJson(updatedDoc.data() as Map<String, dynamic>)
          .copyWith(id: updatedDoc.id);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<PresidentModel> updateImagePresident(String id, String imageUrl) async {
    try {
      await _presidentsCollection.doc(id).update({"CoverImage": imageUrl});
      final updatedDoc = await _presidentsCollection.doc(id).get();
      return PresidentModel.fromJson(updatedDoc.data() as Map<String, dynamic>)
          .copyWith(id: updatedDoc.id);
    } catch (e) {
      throw ServerException();
    }
  }
}
