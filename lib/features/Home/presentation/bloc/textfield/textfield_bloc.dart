
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


part 'textfield_event.dart';
part 'textfield_state.dart';

class TextFieldBloc extends Bloc<TextFieldEvent, TextFieldState> {
  TextFieldBloc() : super(TextFieldInitial(textFieldControllers: [TextEditingController(),TextEditingController()])) {
on<AddTwoTextFieldEvent>(_addTwoTextFields);
on<RemoveTextFieldEvent>(_removeTextFields);
on<ChangeTextFieldEvent>(_ChangeTextfield);
  }
  void _addTwoTextFields(
      AddTwoTextFieldEvent event,
      Emitter<TextFieldState> emit){

emit(state.copyWith(
  textFieldControllers: UnmodifiableListView(
    [
      ...state.textFieldControllers,
      TextEditingController(),
      TextEditingController(),
    ],
  ),
));
  }
void _removeTextFields(
      RemoveTextFieldEvent event,
      Emitter<TextFieldState> emit) {
  final List<TextEditingController> updatedControllers = List.from(state.textFieldControllers);
  for (int index in event.indicesToRemove) {
    if (index >= 0 && index < updatedControllers.length) {
      updatedControllers.removeAt(index);
    }
  }
  emit( state.copyWith(textFieldControllers: updatedControllers));
}
void _ChangeTextfield(
  ChangeTextFieldEvent event,
  Emitter<TextFieldState> emit) {
    emit(TextFieldInitial(textFieldControllers: event.text));
  }


}
