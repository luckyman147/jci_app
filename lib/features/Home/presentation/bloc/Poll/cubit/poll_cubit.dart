import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'poll_state.dart';

class PollCubit extends Cubit<Map<int, bool>> {
  PollCubit() : super({});

  // Toggle the expanded state of a specific template
  void toggleExpand(int index) {
    emit({...state, index: !(state[index] ?? false)});
  }
}