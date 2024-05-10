import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


part 'activity_state.dart';


class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityState(activity.Events));

  void selectActivity(activity activity) {
    emit(ActivityState(activity));
  }
  void selectIndex(int index) {
    emit(state.copyWith(index: index));
  }
void search(bool isSearching) {
    emit(state.copyWith(isSearching: isSearching));
  }
  void selectSearchActivity(activity activity) {
    emit(state.copyWith(selectedSearchActivity: activity,stateChange: StateChange.Changed));
  }
}