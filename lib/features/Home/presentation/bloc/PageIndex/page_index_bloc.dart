import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'page_index_event.dart';
part 'page_index_state.dart';

class PageIndexBloc extends Bloc<PageIndexEvent, PageIndexState> {
  final int initialIndex;

  PageIndexBloc(this.initialIndex) : super(PageIndexInitial(initialIndex)) {
    on<SetIndexEvent>((event, emit) {

      emit(IndexLoaded(event.index));

      // TODO: implement event handler
    });
    on<resetIndex>((event, emit) =>
        emit(PageIndexInitial(0))

    );
  }
}
