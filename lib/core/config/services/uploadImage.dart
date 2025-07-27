import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
class FirebaseImageUploader {
  final _uploadStreamController = StreamController<List<String>>.broadcast();
  final List<String> _uploadedUrls = [];

  /// Stream of uploaded image URLs
  Stream<List<String>> get uploadStream => _uploadStreamController.stream;

  Future<List<String>> uploadImagesToFirebase(List<String> imagePaths) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;

      // List to store uploaded URLs
      List<String> uploadedUrls = [];
      if (imagePaths.isEmpty || imagePaths.any((path) => path.isEmpty)) {
        final fallbackUrl =
        await _uploadAssetImage('assets/images/jci.png', storage);
        uploadedUrls.add(fallbackUrl);
        _uploadStreamController.add(List.from(uploadedUrls));
        return uploadedUrls;
      }
      for (String imagePath in imagePaths) {
        if (_isImageUrl(imagePath)) {
          // If it's already a URL, add it to the list
          uploadedUrls.add(imagePath);
        } else {
          // Otherwise, treat it as a file path and upload it
          File imageFile = File(imagePath);

          // Get a unique filename
          String fileName = basename(imageFile.path);

          // Upload the file to Firebase Storage
          Reference ref = storage.ref().child('uploads/$fileName');
          UploadTask uploadTask = ref.putFile(imageFile);

          // Wait for the upload to complete
          TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

          // Get the download URL
          String downloadUrl = await snapshot.ref.getDownloadURL();
          uploadedUrls.add(downloadUrl);
        }

        // Notify listeners of the new state
        _uploadStreamController.add(List.from(uploadedUrls));
      }
      return uploadedUrls;
    } catch (error) {

      rethrow;
    }
  }
  Future<String> _uploadAssetImage(String assetPath, FirebaseStorage storage) async {
    final byteData = await rootBundle.load(assetPath);
    final fileName = basename(assetPath);
    final ref = storage.ref().child('uploads/$fileName');
    final snapshot = await ref.putData(byteData.buffer.asUint8List());
    return await snapshot.ref.getDownloadURL();
  }
  /// Check if the imagePath is a URL
  bool _isImageUrl(String imagePath) {
    return imagePath.startsWith('http') || imagePath.startsWith('https');
  }

  /// Close the stream controller
  void dispose() {
    _uploadStreamController.close();
  }Future<String> uploadFile({
    required String teamId,
    required String taskId,
    required File file,
    required String fieldName, // Not strictly used for Firebase, but kept for naming if needed
  }) async {
    try {
      final fileName = basename(file.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child('tasks/$teamId/$taskId/$fileName');

      final uploadTask = await ref.putFile(file);

      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      print('Firebase Storage uploadFile error: $error');
      throw Exception('Upload failed: $error');
    }
  }

  refFromURL(fileUrl) async{
    try {
      // Create a reference from a URL
      final ref = FirebaseStorage.instance.refFromURL(fileUrl);
      return ref;
    } catch (error) {
      print('Firebase Storage refFromURL error: $error');
      throw Exception('Reference creation failed: $error');
    }
  }
}


Future<http.StreamedResponse> UpdateImage(String id, String? imagePath,String getUrl) async {
  try {
    // Create a MultipartRequest object
    var request = http.MultipartRequest('PATCH', Uri.parse('$getUrl$id/UpdateImage'));

    // Add the images to the request

    // Create a File object from the file path
    File image = File(imagePath!);


    var multiport = http.MultipartFile(
        'CoverImages',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last
    );

    request.files.add(multiport);

    // Send the request
    var response = await request.send();
    return response;
  } catch (error) {


    // Handle or rethrow the error as needed
    rethrow;
  }
}