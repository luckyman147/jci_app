import 'package:jci_app/features/Home/data/model/TrainingModel/TrainingModel.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';

class Training extends Activity{

  final String ProfesseurName;
  final int Duration;
  final type="Training";

factory Training.fromModel(TrainingModel train) {

  return Training(
    id: train.id,
    name: train.name,
    description: train.description,
    ActivityBeginDate: train.ActivityBeginDate,
    ActivityEndDate: train.ActivityEndDate,
    ActivityAdress: train.ActivityAdress,
    ActivityPoints: train.ActivityPoints,
    categorieId: train.categorieId,
    IsPaid: train.IsPaid,
    price: train.price,
    Participants: train.Participants,
    CoverImages: train.CoverImages,
    Duration: train.Duration,
    ProfesseurName: train.ProfesseurName,
    IsPart: train.IsPart,
    IsPublic: train.IsPublic,
    isOnline: train.isOnline,
    googleMeetLink: train.googleMeetLink,
  );
}

  Training
      ({
    required super.id,

    required this.ProfesseurName, required this.Duration,
    required super.name,


    required super.description, required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress,
    required super.ActivityPoints, required super.categorieId, required super.IsPaid, required super.price, required super.Participants,
    required super.CoverImages, required super.IsPart, required super.IsPublic, required super.isOnline, required super.googleMeetLink,});}