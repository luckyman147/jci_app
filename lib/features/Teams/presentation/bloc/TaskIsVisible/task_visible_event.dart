part of 'task_visible_bloc.dart';

abstract class TaskVisibleEvent extends Equatable {
  const TaskVisibleEvent();
}
class ToggleTaskVisible extends TaskVisibleEvent {
  final bool WillVisible;
  const ToggleTaskVisible(this.WillVisible);
  @override
  List<
      Object> get props => [WillVisible];
}

class resetTaskVisible extends TaskVisibleEvent {
  @override
  List<Object> get props => [];
}
class FullTasks extends TaskVisibleEvent {
  final List<Tasks> tasks;
  const FullTasks(this.tasks);
  @override
  List<Object> get props => [tasks];
}
class DeletedTaskedEvent extends TaskVisibleEvent {
  final bool deleted;
  const DeletedTaskedEvent(this.deleted);
  @override
  List<Object> get props => [deleted];
}
class AddedTaskedEvent extends TaskVisibleEvent {
  final Tasks task;
  const AddedTaskedEvent(this.task);
  @override
  List<Object> get props => [task];
}
class ChangeSectionEvent extends TaskVisibleEvent {
  final Section section;
  const ChangeSectionEvent(this.section);
  @override
  List<Object> get props => [section];
}
class ChangeTextFieldsTitle extends TaskVisibleEvent {
  final TextFieldsTitle textFieldsTitle;
  const ChangeTextFieldsTitle(this.textFieldsTitle);
  @override
  List<Object> get props => [textFieldsTitle];
}
class ChangeTextFieldsDescription extends TaskVisibleEvent {
  final TextFieldsDescription textFieldsDescription;
  const ChangeTextFieldsDescription(this.textFieldsDescription);
  @override
  List<Object> get props => [textFieldsDescription];
}
class ChangeImageEvent extends TaskVisibleEvent {
  final String image;
  const ChangeImageEvent(this.image);
  @override
  List<Object> get props => [image];
}
class ChangeWillSearchEvent extends TaskVisibleEvent {
  final bool willSearch;
  const ChangeWillSearchEvent(this.willSearch);
  @override
  List<Object> get props => [willSearch];
}
class changePrivacyEvent extends TaskVisibleEvent {
  final Privacy privacy;
  const changePrivacyEvent (this.privacy);
  @override
  List<Object> get props => [privacy];
}
class ChangeIsUpdatedEvent extends TaskVisibleEvent {
  final bool isUpdated;
  const ChangeIsUpdatedEvent(this.isUpdated);
  @override
  List<Object> get props => [isUpdated];
}