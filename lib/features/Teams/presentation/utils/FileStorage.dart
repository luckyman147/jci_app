
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../../../Home/Activity_Global.dart';
import '../../domain/entities/TaskFile.dart';
import '../../domain/usecases/TaskUseCase.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import 'package:mime/mime.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
class FileStorage {
  static Future<File> getLocalFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }


  static Future<void> openFile(BuildContext context, String fileid,
      String extension) async {
    try {
      // Save the base64 string as a file

      // context.read<GetTaskBloc>().add(GetFileEvent(fileid));
      await Future.delayed(const Duration(seconds: 2));
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/temp_file.$extension');


      OpenFile.open(
        file.path,
      );

      // Open file
    } catch (e) {

    }
  }

  static Future<List<File>> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg', 'jpeg', 'png', 'pdf', 'docx', 'xlsx',
        'doc', 'ppt', 'txt', 'zip', 'rar',
        'mp4', 'mp3', 'wav', 'mkv', 'avi', 'flv', 'mov', 'webm',
      ],
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files
          .where((file) => file.path != null)
          .map((file) => File(file.path!))
          .toList();
    } else {
      return [];
    }
  }


}