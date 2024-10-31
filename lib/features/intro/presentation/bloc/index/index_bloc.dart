
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'index_event.dart';
part 'index_state.dart';

class IndexBloc extends Bloc<IndexEvent, IndexState> {
  final int initialIndex;

  IndexBloc(this.initialIndex) : super(IndexInitial(initialIndex)) {
    on<SetIndexEvent>((event, emit) {

      emit(IndexLoaded(event.index));

      // TODO: implement event handler
    });
    on<resetIndex>((event, emit) =>
        emit(const IndexInitial(0))

    );
  }

}