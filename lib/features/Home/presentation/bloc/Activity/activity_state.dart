part of 'activity_cubit.dart';


enum activity { Events, Meetings, Trainings }

class ActivityState {
  final activity selectedActivity;

  ActivityState(this.selectedActivity);
}

