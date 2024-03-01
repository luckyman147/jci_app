part of 'textfield_bloc.dart';
abstract class TextFieldEvent extends Equatable {
  const TextFieldEvent();

  @override
  List<Object> get props => [];
}

class AddTextFieldEvent extends TextFieldEvent {}
class AddTwoTextFieldEvent extends TextFieldEvent {}
class RemoveTextFieldEvent extends TextFieldEvent {
  final List<int> indicesToRemove;

  RemoveTextFieldEvent(this.indicesToRemove);
}