part of 'comment_file_bloc.dart';

// Define states for the upload process
enum CommentStatus{ Initial ,InitCommentAdded, Added , Updated, Deleted,Error }
 class CommentFileState {
   final List<File> files; // List of files to be uploaded
   final List<TaskFile> taskFiles; // List of task files>
   final CommentStatus status;
   final TaskComment? comment;
   final String? commentId;

  const CommentFileState({
    this.comment,
    this.commentId,
    this.files = const [],
    this.taskFiles = const [],
    this.status=CommentStatus.Initial,


 });
  CommentFileState copyqWith({
    List<File>? files,
    TaskComment? comment,
    String? commentId,
    CommentStatus? status,
    List<TaskFile>? taskFiles,
    List<TaskComment>? comments,
  }) {
    return CommentFileState(
      commentId: commentId??this.commentId,
      comment: comment?? this.comment,
      status: status?? this.status,
      files: files ?? this.files,
      taskFiles: taskFiles ?? this.taskFiles,

    );
  }

  @override
  List<Object> get props => [ files,status, taskFiles,];
 }

class CommentFileInitial extends CommentFileState {}

class CommentFileUploading extends CommentFileState {
  final List<UploadProgress> progress; // List of progress for each file
  final int totalFiles;
  final int uploadedFiles;


  CommentFileUploading({
    required this.progress,
    required this.totalFiles,
    required this.uploadedFiles,
  });

  CommentFileUploading copyWith({
    List<UploadProgress>? progress,
    int? totalFiles,
    int? uploadedFiles,
  }) {
    return CommentFileUploading(
      progress: progress ?? this.progress,
      totalFiles: totalFiles ?? this.totalFiles,
      uploadedFiles: uploadedFiles ?? this.uploadedFiles,
    );
  }
}

class CommentFileUploadSuccess extends CommentFileState {}

class CommentFileUploadFailure extends CommentFileState {
  final String error;

  CommentFileUploadFailure({required this.error});
}

