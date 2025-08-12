import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart' as FirebaseStorage;

import '../../../../../core/app_theme.dart';
import '../../../../../core/config/services/uploadImage.dart';
import '../../../domain/entities/TaskFile.dart';
import '../../bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../utils/FileStorage.dart';

class FileRowWidget extends StatelessWidget {
  final TaskFile fileData;
  final MediaQueryData mediaQuery;
  final String taskId;

  const FileRowWidget({
    Key? key,
    required this.fileData,
    required this.mediaQuery,
    required this.taskId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String extension = fileData.extension;
    String fileUrl = fileData.url;
    String fileName = Uri.decodeFull(fileUrl.split('/').last);
    IconData iconData = _getIconForExtension(extension);

    return FutureBuilder<File>(
      future: FileStorage.getLocalFile(fileName),
      builder: (context, snapshot) {
        bool isFileDownloaded = snapshot.hasData && snapshot.data!.existsSync();
        double downloadProgress = 0.0;
        bool isDownloading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              alignment: Alignment.center,
              children: [
                _buildFileInfoRow(context, iconData, fileName, snapshot, isFileDownloaded),
              ],
            );
          },
        );
      },
    );
  }

  // File icon and row with file name
  Widget _buildFileInfoRow(BuildContext context, IconData iconData, String fileName, AsyncSnapshot<File> snapshot, bool isFileDownloaded) {
    return InkWell(
      onTap: () async {
        if (isFileDownloaded) {
          await OpenFile.open(snapshot.data!.path);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFileIcon(iconData),
          _buildFileName(fileName),
          _buildDeleteButton(context),
        ],
      ),
    );
  }


  // File icon (based on file extension)
  Widget _buildFileIcon(IconData iconData) {
    return Container(
      decoration: const BoxDecoration(
        color: PrimaryColor,
        shape: BoxShape.circle,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(iconData, size: 20, color: Colors.white),
      ),
    );
  }

  // File name display with overflow handling
  Widget _buildFileName(String fileName) {
    return SizedBox(
      width: mediaQuery.size.width * 0.5,
      child: Text(fileName, overflow: TextOverflow.ellipsis, style: PoppinsRegular(12, textColorBlack)),
    );
  }

  // Delete button
  Widget _buildDeleteButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<TaskVisibleBloc>().add(const ChangeIsUpdatedEvent(true));
      },
      icon: const Icon(Icons.delete, color: textColor, size: 30),
    );
  }

  // Progress indicator for download
  Widget _buildDownloadProgressIndicator(double downloadProgress) {
    return CircularProgressIndicator(
      value: downloadProgress,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation<Color>(PrimaryColor),
    );
  }

  // Get file icon based on file extension
  IconData _getIconForExtension(String extension) {
    final Map<String, IconData> iconMap = {
      '.docx': Icons.description,
      '.pdf': Icons.picture_as_pdf,
      '.jpg': Icons.image,
      '.jpeg': Icons.image,
      '.png': Icons.image,
      '.mp4': Icons.video_library,
      '.avi': Icons.video_library,
      '.mov': Icons.video_library,
      '.wmv': Icons.video_library,
      '.mp3': Icons.music_note,
      '.wav': Icons.music_note,
      '.aac': Icons.music_note,
      '.m4a': Icons.music_note,
      '.ogg': Icons.music_note,
      '.flac': Icons.music_note,
    };

    return iconMap[extension] ?? Icons.insert_drive_file;
  }
}
