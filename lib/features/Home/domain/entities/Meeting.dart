import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/domain/entities/Agenda.dart';

import '../../../../core/PrimitiveUser/User.dart';

class Meeting extends Activity{

 final User Director;
 final List<Agenda> agenda;

 final type="Meeting";
 final String status;
 final int CurrentIndex;



  Meeting( {required super.name, required super.description,required  this.Director,required  this.agenda
   ,required super.id,
    this.CurrentIndex=-1,

this.status="Not Started",
   required super.isOnline,required super.googleMeetLink,
   required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
   required super.categorieId, required super.IsPaid, required super.price, required super.Participants, required super.CoverImages, required super.IsPart, required super.IsPublic, });
}