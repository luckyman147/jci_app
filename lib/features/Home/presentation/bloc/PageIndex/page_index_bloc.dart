
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'page_index_event.dart';
part 'page_index_state.dart';

class PageIndexBloc extends Bloc<PageIndexEvent, PageIndexState> {


  PageIndexBloc() : super(PageIndexInitial()) {
    on<SetIndexEvent>((event, emit) {

      emit(state.copyWith(index: event.index));

      // TODO: implement event handler
    });
    on<SetParticipantIndexEvent>((event, emit) {
      emit(state.copyWith(ParticipantIndex: event.ParticipantIndex));
    });
    on<ChangeViewSectionEvent>((event, emit) {
      emit(state.copyWith(viewsection: event.viewsection));
    });
    on<SetSectionEvent>((event, emit) {
      emit(state.copyWith(section: event.section));});
    on<resetIndex>((event, emit) =>
        emit(state.copyWith(index: 0))

    );
  }
}
