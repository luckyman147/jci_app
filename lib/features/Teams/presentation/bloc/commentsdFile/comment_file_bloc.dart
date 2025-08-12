import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/features/Teams/domain/entities/task/Comment.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import '../../../../../core/config/services/MemberStore.dart';
import '../../../../../core/error/Failure.dart';
import '../../../domain/dto/TaskIdParams.dart';
import '../../../domain/entities/TaskFile.dart';
import '../../../domain/usecases/comments_files_usecases.dart';

part 'comment_file_event.dart';
part 'comment_file_state.dart';

class CommentFileBloc extends Bloc<CommentFileEvent, CommentFileState> {
  final UploadFilesUseCase uploadFilesUseCase;
  final AddCommentUseCase addCommentUseCase ;
final UpdateCommentUseCase updateCommentUseCase;
final DeleteCommentUseCase deleteCommentUseCase;
final MemberStore store;

  List<File> currentFiles = [];

  CommentFileBloc(this.uploadFilesUseCase, this.addCommentUseCase, this.updateCommentUseCase, this.deleteCommentUseCase, this.store) : super(CommentFileInitial()) {
  on<ChangeStatusEvent>((event,emit){
    emit (state.copyqWith(status: event.status));
  });
  on<AddCommentEvent>((event,emit)async{
    final member=await store.getPrimitiveModel();
var comment=event.comment;
    if (member!=null && member.id!=null){
      log("hello");
  comment=    comment.copyWith(avatar: member.Images [0],userName:"${member.firstName} ${member.lastName}");
    }
    emit(state.copyqWith(comment: comment,status:CommentStatus.InitCommentAdded ));
    await Future.delayed(Duration(seconds: 2),()async{
      final result=await addCommentUseCase(comment);
    emit(  _mapFailureOrSuccess(result, emit, (s){
    return   state.copyqWith(status: CommentStatus.Added,commentId: s);

    }));

    });


  });

    // Upload files
    on<UploadFilesEvent>((event, emit) async {
      currentFiles = List.from(event.files);
      final progresses = List.generate(
        event.files.length,
            (_) => UploadProgress(totalBytes: 0, bytesTransferred: 0, progress: 0.0),
      );
emit(state.copyqWith(files: event.files));

      emit(CommentFileUploading(
        progress: progresses,
        totalFiles: event.files.length,
        uploadedFiles: 0,
      ));

      int uploadedCount = 0;
      for (int i = 0; i < event.files.length; i++) {
        final file = event.files[i];

        final stream = uploadFilesUseCase(FileParams(
          teamId: event.teamId,
          taskId: event.taskId,
          files: [file],
        ));

        await emit.forEach(
          stream,
          onData: (result) {
            return result.fold(
                  (failure) => CommentFileUploadFailure(error: mapFailureToMessage(failure)),
                  (uploadProgress) {
                progresses[i] = uploadProgress;

                if (uploadProgress.progress >= 1.0) {
                  uploadedCount++;
                }

                return CommentFileUploading(
                  progress: List.from(progresses),
                  totalFiles: event.files.length,
                  uploadedFiles: uploadedCount,
                );
              },
            );
          },
        );
      }

      emit(CommentFileUploadSuccess());
    });

    // Add file
    on<AddFileToUploadEvent>((event, emit) {
      // Add new files to current list
      currentFiles.addAll(event.files);

      // Get existing state if any
      final oldState = state is CommentFileUploading ? state as CommentFileUploading : null;

      // Copy old progress list or start new
      final List<UploadProgress> progresses = oldState != null
          ? List<UploadProgress>.from(oldState.progress)
          : [];

      // Add a new progress tracker for each new file
      progresses.addAll(List.generate(
        event.files.length,
            (_) => UploadProgress(totalBytes: 0, bytesTransferred: 0, progress: 0.0),
      ));

      // Emit updated state
      emit(CommentFileUploading(
        progress: progresses,
        totalFiles: progresses.length,
        uploadedFiles: oldState?.uploadedFiles ?? 0,
      ));
    });


    // Remove file
    on<RemoveFileFromUploadEvent>((event, emit) {
      final index = currentFiles.indexWhere((f) => f.path == event.file.path);

      if (index != -1) {
        currentFiles.removeAt(index);

        if (state is CommentFileUploading) {
          final currentState = state as CommentFileUploading;
          final progresses = List<UploadProgress>.from(currentState.progress);
          progresses.removeAt(index);

          emit(CommentFileUploading(
            progress: progresses,
            totalFiles: progresses.length,
            uploadedFiles: currentState.uploadedFiles > progresses.length
                ? progresses.length
                : currentState.uploadedFiles,
          ));
        }
      }
    });
  }

  CommentFileState _mapFailureOrSuccess<T>(
      Either<Failure, T> failureOrChecklist, Emitter<CommentFileState> emit, Function(T) onSuccess,{ Function()? onError}) {
    return failureOrChecklist.fold(
          (failure) {
        if (onError!=null){
          return  onError();
        }
        else {
          return state.copyqWith(status: CommentStatus.Error );
        }},
          (task) {
        return onSuccess(task);
      },
    );
  }
}
