

import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';

class activityParams {
  final Activity? act;
  final activity type;
  final String? Eventid;
  final String? name;
  activityParams( {required this.act, required this.type,required this.Eventid,required this.name});
}
class ReminderParams {
  final String ActivityName;
  final String ActivityBeginDate;
  final String location;
  ReminderParams(this.location, {required this.ActivityName,required this.ActivityBeginDate});
}