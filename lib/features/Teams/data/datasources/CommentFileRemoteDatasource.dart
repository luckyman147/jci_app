import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../core/config/services/uploadImage.dart';
import '../../domain/entities/TaskFile.dart';
import 'package:path/path.dart' as p;

import '../models/CommentsModel.dart';
abstract class CommentFileRemoteDataSource {
  Future<String> addComment(CommentModel model);
  // get comments
  Future<List<CommentModel>> getComments(String teamId, String taskId);
  Future<Unit> updateComment(String teamId, String taskId, String commentId, String comment);
  Future<Unit> deleteComment(String teamId, String taskId, String commentId);
  Stream<UploadProgress> uploadFile({
    required String teamId,
    required String taskId,
    required List<File> files,
  });
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
  Future<String> addComment(CommentModel model) async {
    try {
      final ref = await firestore
          .collection('teams')
          .doc(model.TeamId)
          .collection('tasks')
          .doc(model.TaskId)
          .collection('comments')
          .add(model.toJson());

      await ref.update({'Id': ref.id}); // Update the document with its own ID

      return ref.id;
    } catch (e) {
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
        'content': comment,
        'CreatedAt': DateTime.now().toIso8601String(),
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
  Stream<UploadProgress> uploadFile({
    required String teamId,
    required String taskId,
    required List<File> files,
  }) async* {
    try {
      // Start a separate stream for each file
      for (var file in files) {
        // Yield progress for each file
        await for (var progress in storage. uploadFileWithProgress(
          teamId: teamId,
          taskId: taskId,
          file: file,
          onDone: (String downloadUrl) async {
            // Once upload is done for a file, save the metadata to Firestore
            var taskFile = TaskFile.fromParameters(
              url: downloadUrl,
              extension: p.extension(file.path),
            );

            // Save the task file to Firestore
            await firestore
                .collection('teams')
                .doc(teamId)
                .collection('tasks')
                .doc(taskId)
                .collection('files')
                .add(taskFile.toJson());
          },
        )) {
          Logger().i('File upload progress: ${progress.progress}%');
          yield progress; // Yield progress for each file's upload
        }
      }
    } catch (e) {
      print('uploadFile error: $e');
      rethrow;
    }
  }


  @override
  Future<Unit> deleteFile(String teamId, String taskId, String fileddUrl) async {
    try {
      final fileDocs = await firestore
          .collection('teams')
          .doc(teamId)
          .collection('tasks')
          .doc(taskId)
          .collection('files')
          .where('url', isEqualTo: fileddUrl)
          .limit(1)
          .get();

      if (fileDocs.docs.isEmpty) {
        throw Exception('File not found');
      }

      final doc = fileDocs.docs.first;

      // Delete the file from Firebase Storage
      final ref = storage.refFromURL(fileddUrl);
      await ref.delete();

      // Delete the Firestore document
      await doc.reference.delete();
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

  @override
  Future<List<CommentModel>> getComments(String teamId, String taskId) {
    // TODO: implement getComments
    throw UnimplementedError();
  }
}