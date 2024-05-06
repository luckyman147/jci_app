part of 'activity_cubit.dart';


enum activity { Events, Meetings, Trainings }

class ActivityState {
  final activity selectedActivity;
final int index;
  ActivityState(this.selectedActivity,{this.index=0});
  ActivityState copyWith({activity? selectedActivity,int? index}) {
    return ActivityState(selectedActivity ?? this.selectedActivity,index: index??this.index);
  }
}

