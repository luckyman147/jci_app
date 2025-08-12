
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Home/domain/enums/ActionImage.dart';

import '../../../../Home/domain/enums/Privacy.dart';
import '../../../domain/entities/task/Task.dart';

part 'task_visible_event.dart';
part 'task_visible_state.dart';

class TaskVisibleBloc extends Bloc<TaskVisibleEvent, TaskVisibleState> {
  TaskVisibleBloc() : super(const TaskVisibleInitial()) {
    on<TaskVisibleEvent>((event, emit) {
    });
    on<ChangeWillAdded> ((event, emit) {
      emit(state.copyWith(WillAdded: event.willAdded));
    });
    on<ChangeStatusEvent>((event, emit) {
      emit(state.copyWith(status: event.status));
    });
    on<ToggleTaskVisible>(_onToggleTaskVisible);
    on<DeletedTaskedEvent>(ondeleted);
    on<ChangeSectionEvent>(_ChangeSectionEvent);
    on<ChangeIsColumn>((event, emit) {
      emit(state.copyWith(isColumn: event.isColumn));
    });
    on<ToggleTaskVisibleById>(
        (event, emit) {
      emit(state.copyWith(

        SelectedTaskId: event.taskId,
      ));
    });
    on<ChangeTextFieldsTitle>(_changeTextFieldsTitle);
    on<ChangeTextFieldsDescription>(_changeTextFieldsDescription);
    on<ChangeImageEvent>(_ChangeImageEvent);
    on<ChangeWillSearchEvent>(_changeWillSearch);
    on<changePrivacyEvent>(_changePrivacy);
on<InitImagesEvent>((event, emit) {
      emit(state.copyWith(images: event.images));
    });
    on<ChangeIsUpdatedEvent>(_ChangeIsUpdatedEvent);



  }
  void _ChangeIsUpdatedEvent(ChangeIsUpdatedEvent event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(isUpdated: event.isUpdated));
  }
  void _changePrivacy(changePrivacyEvent event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(privacy: event.privacy));
  }
  void _changeWillSearch(ChangeWillSearchEvent event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(willSearch: event.willSearch));
  }
  void
  _ChangeImageEvent(ChangeImageEvent event, Emitter<TaskVisibleState> emit) {
    if (event.action == ActionImage.ADD) {
      emit(state.copyWith(images: [...state.images, event.image],
      status: Status.Changed
      ));
    } else if (event.action == ActionImage.DELETE && event.image.isNotEmpty) {
      emit(state.copyWith(images: state.images.where((e) => e != event.image).toList()
      ,
      status: state.images.isNotEmpty?  Status.Changed:Status.Empty
      ),

      );
    }
    else{
      emit(state.copyWith(images: []));
    }
  }
  void _onToggleTaskVisible(ToggleTaskVisible event, Emitter<TaskVisibleState> emit) {

    emit(state.copyWith(WillAdded: !event.WillVisible));

  }
  void ondeleted(DeletedTaskedEvent event, Emitter<TaskVisibleState> emit) {

    emit(state.copyWith(WillDeleted: !event.deleted));

  }

void _changeTextFieldsTitle(ChangeTextFieldsTitle event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(textFieldsTitle: event.textFieldsTitle));
  }
  void _changeTextFieldsDescription(ChangeTextFieldsDescription event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(textFieldsDescription: event.textFieldsDescription));
  }

  void resetTaskVisible( Emitter<TaskVisibleState> emit) {
    emit(const TaskVisibleInitial());
  }

  void _ChangeSectionEvent(ChangeSectionEvent event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(section: event.section));
  }


}
