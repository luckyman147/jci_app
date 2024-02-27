import 'package:bloc/bloc.dart';


part 'activity_state.dart';


class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityState(activity.Events));

  void selectActivity(activity activity) {
    emit(ActivityState(activity));
  }
}