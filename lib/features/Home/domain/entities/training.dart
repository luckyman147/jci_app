import 'package:jci_app/features/Home/domain/entities/Activity.dart';

class Training extends Activity{

  final String ProfesseurName;
  final int Duration;



  Training
      ({
    required super.id,

    required this.ProfesseurName, required this.Duration,
    required super.name,


    required super.description, required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress,
    required super.ActivityPoints, required super.categorie, required super.IsPaid, required super.price, required super.Participants,
    required super.CoverImages, required super.IsPart,});}