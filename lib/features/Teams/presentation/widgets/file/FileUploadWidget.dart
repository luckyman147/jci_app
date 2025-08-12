import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:path/path.dart' as p;

import '../../bloc/commentsdFile/comment_file_bloc.dart';
import '../../utils/FileStorage.dart';

class FileUploadWidget extends StatelessWidget {
  final List<File> files;
  final String teamId;
  final String taskId;

  FileUploadWidget({
    required this.files,
    required this.teamId,
    required this.taskId,
  });

  // Helper function to check if the file is an image
  bool _isImage(String filePath) {
    final extension = p.extension(filePath).toLowerCase().replaceAll('.', '');
    return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
  }

  // Helper function to check if the file is a video
  bool _isVideo(String filePath) {
    final extension = p.extension(filePath).toLowerCase().replaceAll('.', '');
    return ['mp4', 'mov', 'avi', 'mkv'].contains(extension);
  }

  // Helper function to check if the file is audio
  bool _isAudio(String filePath) {
    final extension = p.extension(filePath).toLowerCase().replaceAll('.', '');
    return ['mp3', 'wav', 'aac', 'flac'].contains(extension);
  }

  // Helper function to return an icon for unsupported file types
  Widget _getFileIcon(String filePath) {
    if (_isImage(filePath)) {
      return ClipOval(
        child: Image.file(
          File(filePath),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      );
    } else if (_isVideo(filePath)) {
      return Icon(
        Icons.videocam,
        size: 60,
        color: Colors.blue,
      );
    } else if (_isAudio(filePath)) {
      return Icon(
        Icons.music_note,
        size: 60,
        color: Colors.green,
      );
    } else {
      return Icon(
        Icons.insert_drive_file,
        size: 60,
        color: Colors.grey,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentFileBloc, CommentFileState>(
      builder: (context, state) {
        if (state is CommentFileUploading) {
          return SizedBox(
            height: 160, // Control height of the horizontal list
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: files.length + 1,
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () async {
                      final picked = await FileStorage.pickFiles();
                      context.read<CommentFileBloc>().add(
                        AddFileToUploadEvent(files: picked),
                      );
                    },
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorsApp.ThirdColor, width: 1.5),
                      ),
                      child: Center(
                        child: Icon(Icons.add, size: 40, color: Colors.grey),
                      ),
                    ),
                  );
                }

                final realIndex = index - 1;
                final progress = state.progress[realIndex];
                final file = files[realIndex];
                final filePath = file.path;

                return Container(

                  padding:  paddingSemetricVerticalHorizontal(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorsApp.ThirdColor, width: 1.5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 120,
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            _getFileIcon(filePath),

                      SizedBox(height: 6),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,

                      child:
                      CircularProgressIndicator(
                        value: progress.progress,
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress.progress==1.0 ? ColorsApp.SecondaryColor :ColorsApp.textColorWhite,
                        ),
                      )),
                            Positioned(
                        bottom: 0,
                        right: 0,
                        top: 0,
                        left: 0,
                        child: IconButton(
                          icon: Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            context.read<CommentFileBloc>().add(
                              RemoveFileFromUploadEvent(file: file),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                      SizedBox(height: 6),
                      Text(
                        p.basename(file.path),
                        style: PoppinsLight(13, ColorsApp.textColorBlack),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (state is CommentFileUploadSuccess) {
          return Text('Upload complete!');
        } else if (state is CommentFileUploadFailure) {
          return Text('Error: ${state.error}');
        }

        return SizedBox.shrink();
      },
    );
  }

}
