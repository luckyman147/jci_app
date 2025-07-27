
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/Exception.dart';
import '../../domain/entities/task/Task.dart';
import '../models/TaskModel.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasksOfTeam(String teamId);
  Future<TaskModel> getTasksById(String teamId, String taskId);
  Future<TaskModel> addTask(String teamId, String name);
  Future<Unit> deleteTask(String teamId, String taskId);
  Future<Unit> updateIsCompleted(String teamId, String taskId, TaskCompletionStatus status);
  Future<Unit> updateTaskName(String teamId, String taskId, String name);
  Future<Unit> updateTimeline(String teamId, String taskId, DateTime startDate, DateTime deadline);
  Future<Unit> updateMembers(String teamId, String taskId, bool status, String memberId);
}

class TaskFirestoreRemote implements TaskRemoteDataSource {
  final FirebaseFirestore _firestore;

  TaskFirestoreRemote(this._firestore);

  @override
  Future<List<TaskModel>> getTasksOfTeam(String teamId) async {
  try {
    final snapshot = await _firestore
        .collection('teams')
        .doc(teamId)
        .collection('tasks')
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return TaskModel.fromJson(data);
    }).toList();
  }
  catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<TaskModel> getTasksById(String teamId, String taskId) async {
try {
    final doc = await _firestore
        .collection('teams')
        .doc(teamId)
        .collection('tasks')
        .doc(taskId)
        .get();
    if (!doc.exists) throw EmptyDataException();
    final data = doc.data()!;
    data['id'] = doc.id;
    return TaskModel.fromJson(data);
  }
  catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<TaskModel> addTask(String teamId, String name) async {
 try {
    final ref = await _firestore
        .collection('teams')
        .doc(teamId)
        .collection('tasks')
        .add(TaskModel.toJsonWithNameAndId(name));

    final doc = await ref.get();
    final data = doc.data()!..['id'] = doc.id;
    return TaskModel.fromJson(data);
  } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteTask(String teamId, String taskId) async {
 try {
      await _firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .delete();
      return unit;
    } catch (e) {
      throw ServerException();
    }

  }

  @override
  Future<Unit> updateIsCompleted(String teamId, String taskId, TaskCompletionStatus status) async {
  try {
      await _firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .update({'meta.isCompleted': status.index});
      return unit;
    } catch (e) {
      throw ServerException();
    }

  }

  @override
  Future<Unit> updateTaskName(String teamId, String taskId, String name) async {
   try {
      await _firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .update({'meta.name': name});    return unit;
    } catch (e) {
      throw ServerException();
    }


  }

  @override
  Future<Unit> updateTimeline(String teamId, String taskId, DateTime startDate, DateTime deadline) async {
  try {
    await _firestore
        .collection('teams')
        .doc(teamId)
        .collection('tasks')
        .doc(taskId)
        .update({
      'meta.startDate': Timestamp.fromDate(startDate),
      'meta.deadline': Timestamp.fromDate(deadline),
    });
    return unit;
  }
  catch (e) {
    throw ServerException();}

  }

  @override
  Future<Unit> updateMembers(String teamId, String taskId, bool status, String memberId) async {
   try {
    final taskRef = _firestore
        .collection('teams')
        .doc(teamId)
        .collection('tasks')
        .doc(taskId);

    if (status) {
      await taskRef.update({
        'meta.assignToImages': FieldValue.arrayUnion([memberId])
      });
    } else {
      await taskRef.update({
        'meta.assignToImages': FieldValue.arrayRemove([memberId])
      });
    }
    return unit;
  }
  catch (e) {
      throw ServerException();
    }
  }
}
