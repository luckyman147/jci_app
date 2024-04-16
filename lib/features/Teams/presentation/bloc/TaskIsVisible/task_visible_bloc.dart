import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/Task.dart';

part 'task_visible_event.dart';
part 'task_visible_state.dart';

class TaskVisibleBloc extends Bloc<TaskVisibleEvent, TaskVisibleState> {
  TaskVisibleBloc() : super(TaskVisibleInitial()) {
    on<TaskVisibleEvent>((event, emit) {
    });
    on<ToggleTaskVisible>(_onToggleTaskVisible);
    on<DeletedTaskedEvent>(ondeleted);
    on<ChangeSectionEvent>(_ChangeSectionEvent);
    on<ChangeTextFieldsTitle>(_changeTextFieldsTitle);
    on<ChangeTextFieldsDescription>(_changeTextFieldsDescription);
    on<ChangeImageEvent>(_ChangeImageEvent);
    on<ChangeWillSearchEvent>(_changeWillSearch);
    on<changePrivacyEvent>(_changePrivacy);

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
  void _ChangeImageEvent(ChangeImageEvent event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(image: event.image));
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
    emit(TaskVisibleInitial());
  }

  void _ChangeSectionEvent(ChangeSectionEvent event, Emitter<TaskVisibleState> emit) {
    emit(state.copyWith(section: event.section));
  }


}
