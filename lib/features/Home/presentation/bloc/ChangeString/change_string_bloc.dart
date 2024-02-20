import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'change_string_event.dart';
part 'change_string_state.dart';

class ChangeStringBloc extends Bloc<ChangeStringEvent, ChangeStringState> {
  final String initialValue;
  ChangeStringBloc(this.initialValue) : super(ChangeStringInitial(initialValue)) {
    on<SetStringEvent>((event, emit) {
      emit(StringLoaded(event.value));
      // TODO: implement event handler
    });
    on<resetString>((event, emit) =>
        emit(ChangeStringInitial('Event'))
    );
  }
}
