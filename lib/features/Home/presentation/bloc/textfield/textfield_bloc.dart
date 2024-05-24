
import 'dart:collection';
import 'dart:developer';

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
  log(updatedControllers.toString());
  log(event.indicesToRemove.toString());

// Collect the controllers to remove
  final List<TextEditingController> controllersToRemove = [];
  for (int index in event.indicesToRemove) {
    if (index >= 0 && index < updatedControllers.length) {
      controllersToRemove.add(updatedControllers[index]);
    }
  }

// Remove the collected controllers
  for (var controller in controllersToRemove) {
    updatedControllers.remove(controller);
  }

  log(updatedControllers.toString());

  emit(state.copyWith(textFieldControllers: updatedControllers));

}
void _ChangeTextfield(
  ChangeTextFieldEvent event,
  Emitter<TextFieldState> emit) {
    emit(TextfieldChanged(event.text,textFieldControllers: event.text));
    emit(state.copyWith(textFieldControllers: event.text));
  }


}
