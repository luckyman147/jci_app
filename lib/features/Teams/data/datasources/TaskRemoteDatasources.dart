
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/PrimitiveUser/UserModel.dart';
import 'package:jci_app/features/Teams/data/models/CheckListModel.dart';

import '../../../../../core/error/Exception.dart';
import '../../../auth/AuthWidgetGlobal.dart';
import '../../domain/entities/TaskFile.dart';
import '../../domain/entities/TeamUser.dart';
import '../../domain/entities/task/Task.dart';
import '../models/CommentsModel.dart';
import '../models/TaskModel.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasksOfTeam(String teamId);
  Future<TaskModel> getTasksById(String teamId, String taskId);
  Future<TaskModel> addTask(String teamId, String name,TaskCompletionStatus status);
  Future<Unit> deleteTask(String teamId, String taskId);
  Future<Unit> updateIsCompleted(String teamId, String taskId, TaskCompletionStatus status);
  Future<Unit> updateTaskName(String teamId, String taskId, String name);
  Future<Unit> updateTaskDescription(String teamId, String taskId, String name);
  Future<Unit> updateTimeline(String teamId, String taskId, DateTime startDate, DateTime deadline);
  Future<Unit> updateMembers(String teamId, String taskId, bool status, TeamUser memberId);
  Future<Unit> updateMembersRole(String teamId, String taskId, String  newrole, String memberId);
}

class TaskFirestoreRemote implements TaskRemoteDataSource {
  final FirebaseFirestore _firestore;

  TaskFirestoreRemote(this._firestore);

  @override
  Future<List<TaskModel>> getTasksOfTeam(String teamId) async {
    try {
      final tasksSnapshot = await _firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .get();


      final tasks = await Future.wait(
        tasksSnapshot.docs.map((doc) => _getTaskWithFiles(teamId: teamId, taskDoc: doc)),
      );

      return tasks;
    } catch (e, stack) {
      Logger().e('Error fetching tasks of team: $e', error: e, stackTrace: stack);
      throw ServerException();
    }
  }
  Future<TaskModel> _getTaskWithFiles({
    required String teamId,
    required DocumentSnapshot<Map<String, dynamic>> taskDoc,
  }) async {
    final taskData = taskDoc.data()!;
    final taskId = taskDoc.id;

    final task = TaskModel.fromJson({...taskData, 'id': taskId});

    // Run all fetches in parallel
    final results = await Future.wait([
      _fetchFiles(teamId, taskId),
      _fetchComments(teamId, taskId),
      _fetchChecklists(teamId, taskId),
    ]);

    final files = results[0] as List<TaskFile>;
    final comments = results[1] as List<CommentModel>;
    final checklists = results[2] as List<CheckListModel>;

    return task.copyWith(
      content: task.content.copyWith(
        attachedFiles: files,
        checkLists: checklists,
      ),
      communication: task.communication.copyWith(
        comments: comments,
      ),
    ).toModel();
  }

  Future<List<TaskFile>> _fetchFiles(String teamId, String taskId) async {
    final snapshot = await _firestore
        .collection('teams')
        .doc(teamId)
        .collection('tasks')
        .doc(taskId)
        .collection('files')
        .get();

    return snapshot.docs.map((doc) => TaskFile.fromJson(doc.data())).toList();
  }

  Future<List<CommentModel>> _fetchComments(String teamId, String taskId) async {
    final snapshot = await _firestore
        .collection('teams')
        .doc(teamId)
        .collection('tasks')
        .doc(taskId)
        .collection('comments')
        .get();

    return snapshot.docs.map((doc) => CommentModel.fromJson(doc.data())).toList();
  }

  Future<List<CheckListModel>> _fetchChecklists(String teamId, String taskId) async {
    final snapshot = await _firestore
        .collection('teams')
        .doc(teamId)
        .collection('tasks')
        .doc(taskId)
        .collection('checklists')
        .get();

    return snapshot.docs.map((doc) => CheckListModel.fromJson(doc.data(),null)).toList();
  }

  @override
  Future<TaskModel> addTask(String teamId, String name, TaskCompletionStatus status) async {
 try {
    final ref = await _firestore
        .collection('teams')
        .doc(teamId)
        .collection('tasks')
        .add(TaskModel.toJsonWithNameAndId(name,status));

    final doc = await ref.get();
    await ref.update({'meta.id': doc.id});
    await _firestore
        .collection('teams')
        .doc(teamId)
        .update({
      'stats.numberOfTasksTotal': FieldValue.increment(1),
      'stats.numberOfTasksCompleted':FieldValue.increment(status==TaskCompletionStatus.Completed?1:0)
    });
    // update team.stats.numberOfTasksTotal
    //update the document with the generated ID

    if (!doc.exists) throw EmptyDataException();
    final data = doc.data()!..['meta']['id'] = doc.id;

    return TaskModel.fromJson(data);
  } catch (e) {
   Logger().e('Error adding task: $e');
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteTask(String teamId, String taskId) async {
    try {
      Logger().i('Deleting task with ID: $taskId from team: $teamId');

      // 1️⃣ Get the task document before deleting
      final taskDoc = await _firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .get();

      if (!taskDoc.exists) {
        Logger().w('Task not found, skipping delete.');
        return unit;
      }

      final taskData = taskDoc.data() ?? {};
      final isCompleted = taskData['meta']?['status'] == 'Completed';

      // 2️⃣ Delete the task
      await taskDoc.reference.delete();

      // 3️⃣ Update stats accordingly
      final updates = {
        'stats.numberOfTasksTotal': FieldValue.increment(-1),
      };

      if (isCompleted) {
        updates['stats.numberOfTasksCompleted'] = FieldValue.increment(-1);
      }

      await _firestore
          .collection('teams')
          .doc(teamId)
          .update(updates);

      return unit;
    } catch (e ) {
      Logger().e('Error deleting task');
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateIsCompleted(
      String teamId, String taskId, TaskCompletionStatus status) async {
    try {
      final taskRef = _firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId);

      // 1️⃣ Get current task data
      final taskDoc = await taskRef.get();
      if (!taskDoc.exists) {
        Logger().w('Task not found: $taskId in team $teamId');
        return unit;
      }

      final oldStatus = taskDoc.data()?['meta']?['status'];

      // 2️⃣ Update the task status
      await taskRef.update({'meta.status': status.name});

      // 3️⃣ Update team stats if needed
      final updates = <String, dynamic>{};

      if (oldStatus != 'Completed' && status.name == 'Completed') {
        // Changed from not completed → completed
        updates['stats.numberOfTasksCompleted'] = FieldValue.increment(1);
      } else if (oldStatus == 'Completed' && status.name != 'Completed') {
        // Changed from completed → not completed
        updates['stats.numberOfTasksCompleted'] = FieldValue.increment(-1);
      }

      if (updates.isNotEmpty) {
        await _firestore.collection('teams').doc(teamId).update(updates);
      }

      return unit;
    } catch (e) {
      Logger().e('Error updating task status');
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
      'meta.startDate': startDate.toIso8601String(),
      'meta.deadline': deadline.toIso8601String(),
    });
    return unit;
  }
  catch (e) {
    throw ServerException();}

  }

  @override
  Future<Unit> updateMembers(String teamId, String taskId, bool status, TeamUser memberId) async {
   try {
    final taskRef = _firestore
        .collection('teams')
        .doc(teamId)
        .collection('tasks')
        .doc(taskId);

    if (status) {
      await taskRef.update({
        'meta.assignToMembers': FieldValue.arrayUnion([memberId.toJson()])
      });
    } else {
      await taskRef.update({
        'meta.assignToMembers': FieldValue.arrayRemove([memberId.toJson()])
      });
    }
    Logger().i('Updated members for task $taskId in team $teamId with status $status');
    return unit;
  }

  catch (e) {
Logger().e('Error updating members: $e');
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateTaskDescription(String teamId, String taskId, String description) async{
    try {
      await _firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .update({'content.description': description});    return unit;
    } catch (e) {
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

      return await _getTaskWithFiles(teamId: teamId, taskDoc: doc);
    } catch (e, stack) {
      Logger().e('Error fetching task by ID: $e', error: e, stackTrace: stack);
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateMembersRole(String teamId, String taskId, String newRole, String memberId)async {
    try {
      final teamRef = _firestore.collection('teams').doc(teamId);
      final taskRef = teamRef.collection('tasks').doc(taskId);

      final taskSnap = await taskRef.get();

      if (!taskSnap.exists) {
        Logger().w('Task not found: $taskId in team $teamId');
        throw EmptyDataException();
      }

      final taskData = taskSnap.data()!;
      final List<dynamic> assignToMembers = taskData['meta']['assignToMembers'] ?? [];

      // Update the role of the matching member
      final updatedMembers = assignToMembers.map((member) {
        if (member['user']['id'] == memberId) {
          Logger().w('updating role for member: ${member['user']['id']} to $newRole');



          return {
            ...member,
            'role': newRole,
          };
        }
        return member;
      }).toList();

      await taskRef.update({
        'meta.assignToMembers': updatedMembers,
      });

      return unit;
    } catch (e) {
      Logger().e('Error updating member role: $e');
      throw ServerFailure();
    }
  }


}
