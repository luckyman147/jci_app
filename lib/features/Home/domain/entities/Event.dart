

import 'package:jci_app/features/Home/domain/entities/Activity.dart';

class Event  extends Activity{

  final String LeaderName;
  final DateTime registrationDeadline;



  Event( {required this.registrationDeadline,   required this.LeaderName,

      required super.name, required super.description, required super.ActivityBeginDate,
    required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints, required super.categorie,
    required super.IsPaid, required super.price, required super.Participants, required super.CoverImages, required super.id, required super.IsPart, });

   @override
   // TODO: implement props
   List<Object?> get props => [LeaderName, registrationDeadline, name,
     description, ActivityBeginDate, ActivityEndDate, ActivityAdress,
     ActivityPoints, categorie, IsPaid, price, Participants, CoverImages, id, IsPart];

}
