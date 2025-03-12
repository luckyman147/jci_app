
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'change_string_event.dart';
part 'change_string_state.dart';

class ChangeStringBloc extends Bloc<ChangeStringEvent, ChangeStringState> {

  ChangeStringBloc() : super(ChangeStringInitial()) {
    on<SetImageEvent>((event, emit) {
      emit(state.copyWith(image
          : event.image));
      // TODO: implement event handler
    });
    on<initImageEvent>((event, emit) {
      if (event.image.isNotEmpty) {
        emit(state.copyWith(image: event.image[0]));
      }
    }
    );

  }
}
