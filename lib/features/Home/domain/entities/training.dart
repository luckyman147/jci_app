import 'package:jci_app/features/Home/data/model/TrainingModel/TrainingModel.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/Activity.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/ActivityBasics.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/ActivitySettings.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/OnlineSettings.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/ParicipationStatus.dart';

class Training extends Activity {
  final String professeurName;
  final int duration;


  Training({
    required this.professeurName,
    required this.duration,
    required super.activityBasics,
    required super.settings,
    required super.online,
    super. type,
    required super.participation,
  });

  factory Training.fromModel(TrainingModel train) {
    return Training(
      professeurName: train.professeurName,
      duration: train.duration,
      activityBasics: train.activityBasics,
      settings: train.settings,
      online: train.online,
      participation: train.participation,
    );
  }

  @override
  List<Object?> get props => [
    professeurName,
    duration,
    activityBasics,
    settings,
    online,
    participation,
  ];
}
