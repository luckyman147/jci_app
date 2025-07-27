import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/model/PVModel.dart';
import 'package:logger/logger.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart' as open;

import '../../../../../core/config/env/urls.dart';

abstract class PVremoteDataSource {
  Future<List<PvModel>> getPVs(String activityId);
  Future<Unit> addPV(PvModel pv,String activityId);
  Future<Unit> deletePV(String id,String activityId);
  Future<String> UploadFileToStorage(String path);
  Future<Unit> SendNotificationPV(String ActivityId,String PVId);
  Future<Unit> downloadAndOpenFile(String firebaseStorageUrl, String fileName);
}class PVRemoteDataSourceImpl implements PVremoteDataSource {
  final Logger logger;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  PVRemoteDataSourceImpl({
    required this.logger,
    required this.firestore,
    required this.storage,
  });

  @override
  Future<List<PvModel>> getPVs(String activityId) async {
    return await handleError(() async {
      final querySnapshot = await firestore
          .collection('activities')
          .doc(activityId)
          .collection('pvs')
          .get();

      logger.i("Fetched ${querySnapshot.size} PVs for activity $activityId.");
      final pvList = querySnapshot.docs.map((doc) {
        return PvModel.fromMap(doc.data());
      }).toList();



      logger.i("Fetched ${pvList.length} PVs for activity $activityId.");
      return pvList;
    }, "getPVs");
  }

  @override
  Future<Unit> addPV(PvModel pv, String activityId) async {
    return await handleError(() async {
      final documentRef = firestore
          .collection('activities')
          .doc(activityId)
          .collection('pvs')
          .doc();

      await documentRef.set(pv.toMap());
      //update the id with document id
      await documentRef.update({'id': documentRef.id});
      logger.i("Added PV with ID ${documentRef.id} to activity $activityId.");
  await SendNotificationPV(activityId, documentRef.id);
      return unit;
    }, "addPV");
  }

  @override
  Future<Unit> deletePV(String id, String activityId) async {
    return await handleError(() async {

      final documentRef = firestore
          .collection('activities')
          .doc(activityId)
          .collection('pvs')
          .doc(id);
//delete from storage
      final pv = await documentRef.get();
      final pvModel = PvModel.fromMap(pv.data()!);
      final ref = storage.ref().child('uploads/${pvModel.title}');
      await ref.delete();
      await documentRef.delete();


      logger.i("Deleted PV with ID $id from activity $activityId.");
      return unit;
    }, "deletePV");
  }

  @override
  Future<String> UploadFileToStorage(String path) async {
    return await handleError(() async {
      final fileName = path.split('/').last;
      final ref = storage.ref().child('uploads/$fileName');

      // Upload file
      final uploadTask = ref.putFile(File(path));
      await uploadTask;

      // Get download URL
      final downloadUrl = await ref.getDownloadURL();

      logger.i("Uploaded file to storage and obtained URL: $downloadUrl.");
      return downloadUrl;
    }, "uploadFileToStorage");
  }

  @override
  Future<Unit> downloadAndOpenFile(String firebaseStorageUrl, String fileName)async {
    try {
      // Step 1: Get a directory to save the file locally
      final directory = await getApplicationDocumentsDirectory();
      final localFilePath = "${directory.path}/$fileName";

      // Step 2: Send an HTTP GET request to Firebase Storage URL
      final response = await http.get(Uri.parse(firebaseStorageUrl));

      if (response.statusCode == 200) {
        // Step 3: Save the downloaded file to local storage
        final file = File(localFilePath);
        await file.writeAsBytes(response.bodyBytes);


        final result = await open. OpenFile.open(localFilePath);

        if (result.type !=open. ResultType.done) {
          logger.e("Failed to open file: ${result.message}");
          throw ServerException();
        }

        return unit;
      } else {
        logger.e("Failed to download file. HTTP status: ${response.statusCode}");
        throw ServerException();
      }
    } catch (e) {
      logger.e("Error downloading or opening the file: $e");
      throw ServerException();
    }
  }

  @override
  Future<Unit> SendNotificationPV(String ActivityId, String PVId)async {
    try {
      final url = '${Urls
          .mainurl}/sendNotificationOnNewPV?activityId=$ActivityId&PVId=$PVId';
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        Logger().i('succefully : $response');
        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      } else {
        Logger().e('wrong: ${response.body}');
        throw NotVerifiedException();
      }
    } catch (e) {
      Logger().e('ParticiActionActivity: $e');
      throw ServerException();
    }
  }

}


Future<T> handleError<T>(Future<T> Function() function, String operation) async {
  try {
    return await function();
  } on FirebaseException catch (e) {
    // show all possible exception
    if (e.code == 'permission-denied') {
      Logger().e("Permission denied in $operation: $e");
      throw UnauthorizedException();
    } else if (e.code == 'not-found') {
      Logger().e("Document not found in $operation: $e");
      throw NotFoundException();
    } else {
      Logger().e("Unexpected Firebase error in $operation: $e");
      throw ServerException();
    }
  } catch (e) {
    Logger().e("Unexpected error in $operation: $e");
   throw ServerException();
  }
}

