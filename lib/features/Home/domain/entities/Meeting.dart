import 'package:jci_app/features/Home/domain/entities/Activitys/Activity.dart';
import 'package:jci_app/features/Home/domain/entities/Agenda.dart';

import '../../../../core/PrimitiveUser/User.dart';

import 'package:jci_app/features/Home/domain/entities/Activitys/Activity.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/ActivityBasics.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/ActivitySettings.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/OnlineSettings.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/ParicipationStatus.dart';
import 'package:jci_app/core/PrimitiveUser/User.dart';
import 'package:equatable/equatable.dart';

class Meeting extends Activity {
  final User director;
  final List<Agenda> agenda;
  final String type = "Meeting";
  final String status;
  final int currentIndex;

  Meeting({
    required this.director,
    required this.agenda,
    this.status = "Not Started",
    super.type="Meeting",
    this.currentIndex = -1,
    required super.activityBasics,
    required super.settings,
    required super.online,
    required super.participation,
  });

  @override
  List<Object?> get props => [
    director,
    agenda,
    status,
    currentIndex,
    activityBasics,
    settings,
    online,
    participation,
  ];
}
