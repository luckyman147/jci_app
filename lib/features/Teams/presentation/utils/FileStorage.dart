
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



  static Future<void> openFile(
      BuildContext context, String fileid, String extension) async {
    try {
      // Save the base64 string as a file

     // context.read<GetTaskBloc>().add(GetFileEvent(fileid));
      final state = BlocProvider.of<GetTaskBloc>(context).state;
      await Future.delayed(const Duration(seconds: 2));
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/temp_file.$extension');
      await file.writeAsBytes(state.image!);

      OpenFile.open(
        file.path,
      );

      // Open file
    } catch (e) {

    }
  }
}
