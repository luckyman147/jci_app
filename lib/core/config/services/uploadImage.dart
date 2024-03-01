import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<http.StreamedResponse> uploadImages(String id, String? imagePath,String getUrl) async {
  try {
    // Create a MultipartRequest object
    var request = http.MultipartRequest('POST', Uri.parse('$getUrl$id/uploadImage'));

    // Add the images to the request

    // Create a File object from the file path
    File image = File(imagePath!);
    debugPrint("image $image");
    var stream = http.ByteStream(image!.openRead());


    var length = await image!.length();
    var multiport = http.MultipartFile(
        'CoverImages',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.path.split('/').last
    );

    request.files.add(multiport);

    // Send the request
    var response = await request.send();
    debugPrint(response.toString());
    debugPrint(response.request.toString());
    return response;
  } catch (error) {
    // Log the error
    debugPrint('Error during image upload: $error');

    // Handle or rethrow the error as needed
    throw error;
  }
}