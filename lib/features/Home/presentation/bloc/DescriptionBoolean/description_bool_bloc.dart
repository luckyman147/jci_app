import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'description_bool_event.dart';
part 'description_bool_state.dart';

class DescriptionBoolBloc
    extends Bloc<DescriptionBoolEvent, DescriptionBoolState> {
  DescriptionBoolBloc() : super(DescriptionBoolInitial(false)) {
    on<DescriptionBoolEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ShowFullDescriptionEvent>(_showFullDescription);
  }
  void _showFullDescription(
      ShowFullDescriptionEvent event, Emitter<DescriptionBoolState> emit) {
    emit(DescriptionToggleState(!state.isFullDescription));
  }
}
