import 'package:jci_app/features/Home/domain/entities/Activity.dart';

class Meeting extends Activity{

 final dynamic Director;
  final int Duration;

  Meeting( {required super.name, required super.description,required  this.Director,required  this.Duration,required super.id,
   required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
   required super.categorie, required super.IsPaid, required super.price, required super.Participants, required super.CoverImages, });
}