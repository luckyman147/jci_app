import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Teams/data/models/CheckListModel.dart';

abstract class ChecklistRemoteDataSource {
  Future<CheckListModel> addChecklist(String teamId, String taskId, String name);
  Future<Unit> updateChecklist(String teamId, String taskId, String checklistId, CheckListModel checklist);
  Future<Unit> updateChecklistName(String teamId, String taskId, String checklistId, String name);
  Future<Unit> updateChecklistStatus(String teamId, String taskId, String checklistId, bool isCompleted);
  Future<Unit> deleteChecklist(String teamId, String taskId, String checklistId);
  Future<List<CheckListModel>> getChecklists(String teamId, String taskId);
}
class ChecklistRemoteDataSourceImpl implements ChecklistRemoteDataSource {
  final FirebaseFirestore firestore;

  ChecklistRemoteDataSourceImpl(this.firestore);

  @override
  Future<CheckListModel> addChecklist(String teamId, String taskId, String name) async {
    try {
      final docRef = await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('checklists')
          .add(CheckListModel.toJsonForCreate(name));

      return CheckListModel(
        id: docRef.id,
        name: name,
        isCompleted: false,
      );
    } catch (e) {
      throw Exception('Error adding checklist: $e');
    }
  }

  @override
  Future<Unit> updateChecklist(
      String teamId,
      String taskId,
      String checklistId,
      CheckListModel checklist,
      ) async {
    try {
      await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('checklists')
          .doc(checklistId)
          .update(checklist.toJson());
      return unit;
    } catch (e) {
      throw Exception('Error updating checklist: $e');
    }
  }

  @override
  Future<Unit> updateChecklistName(String teamId, String taskId, String checklistId, String name) async {
    try {
      await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('checklists')
          .doc(checklistId)
          .update({'name': name});

      return unit;

    } catch (e) {
      throw Exception('Error updating checklist name: $e');
    }
  }

  @override
  Future<Unit> updateChecklistStatus(String teamId, String taskId, String checklistId, bool isCompleted) async {
    try {
      await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('checklists')
          .doc(checklistId)
          .update({'isCompleted': isCompleted});
      return unit;

    } catch (e) {
      throw Exception('Error updating checklist status: $e');
    }
  }

  @override
  Future<Unit> deleteChecklist(String teamId, String taskId, String checklistId) async {
    try {
      await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('checklists')
          .doc(checklistId)
          .delete();
      return unit;
    } catch (e) {
      throw Exception('Error deleting checklist: $e');
    }
  }

  @override
  Future<List<CheckListModel>> getChecklists(String teamId, String taskId) async{
    try {
      final snapshot = await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('checklists')
          .get();

      return snapshot.docs.map((doc) {
        return CheckListModel.fromJson(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching checklists: $e');
    }
  }
}