import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/config/services/uploadImage.dart';
import '../../domain/entities/TaskFile.dart';
import 'package:path/path.dart' as p;
abstract class CommentFileRemoteDataSource {
  Future<Unit> addComment(String teamId, String taskId, String comment);
  Future<Unit> updateComment(String teamId, String taskId, String commentId, String comment);
  Future<Unit> deleteComment(String teamId, String taskId, String commentId);
  Future<TaskFile> uploadFile(String teamId, String taskId, File bytes, String fileName);
  Future<Unit> deleteFile(String teamId, String taskId, String fileId);
  Future<List<TaskFile>> getFiles(String teamId, String taskId);
}

class CommentFileRemoteDataSourceImpl implements CommentFileRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseImageUploader storage;

  CommentFileRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Future<Unit> addComment(String teamId, String taskId, String comment) async {
    try {
      await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('comments')
          .add({
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return unit;
    } catch (e) {
      print('addComment error: $e');
      rethrow;
    }
  }

  @override
  Future<Unit> updateComment(String teamId, String taskId, String commentId, String comment) async {
    try {
      await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('comments')
          .doc(commentId)
          .update({
        'comment': comment,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return unit;
    } catch (e) {
      print('updateComment error: $e');
      rethrow;
    }
  }

  @override
  Future<Unit> deleteComment(String teamId, String taskId, String commentId) async {
    try {
      await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('comments')
          .doc(commentId)
          .delete();
      return unit;
    } catch (e) {
      print('deleteComment error: $e');
      rethrow;
    }
  }

  @override
  Future<TaskFile> uploadFile(String teamId, String taskId,File file, String fileName) async {
    try {
      final fileRef =await storage.uploadFile(teamId: teamId, taskId: taskId, file: file, fieldName: fileName);

      var taskFile = TaskFile.fromParameters(url: fileRef, extension:p.extension(file.path)  );
      final docRef = await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('files')
          .add(taskFile.toJson());

      return  taskFile;
    } catch (e) {
      print('uploadFile error: $e');
      rethrow;
    }
  }

  @override
  Future<Unit> deleteFile(String teamId, String taskId, String fileId) async {
    try {
      final fileDoc = firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('files')
          .doc(fileId);

      final snapshot = await fileDoc.get();
      final fileUrl = snapshot.data()?['url'];

      if (fileUrl != null) {
        final ref = storage.refFromURL(fileUrl);
        await ref.delete();
      }

      await fileDoc.delete();
      return unit;
    } catch (e) {
      print('deleteFile error: $e');
      rethrow;
    }
  }

  @override
  Future<List<TaskFile>> getFiles(String teamId, String taskId) async {
    try {
      final query = await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('files')
          .get();

      return query.docs
          .map((doc) => TaskFile.fromJson( doc.data()))
          .toList();
    } catch (e) {
      print('getFiles error: $e');
      rethrow;
    }
  }
}