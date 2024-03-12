part of 'textfield_bloc.dart';

class TextFieldState extends Equatable {
  final List<TextEditingController> textFieldControllers;

  const TextFieldState({required this.textFieldControllers});

  TextFieldState copyWith({List<TextEditingController>? textFieldControllers}) {
    return TextFieldState(
      textFieldControllers: textFieldControllers ?? this.textFieldControllers,
    );
  }

  @override
  List<Object> get props => [textFieldControllers];
}
class TextFieldInitial extends TextFieldState{
  TextFieldInitial({required super.textFieldControllers});
}
class TextfieldChanged extends TextFieldState{
  final List<TextEditingController> pp;

  TextfieldChanged(this.pp, {required super.textFieldControllers});
}