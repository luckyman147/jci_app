import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

class Meeting extends Activity{

 final dynamic Director;
 final List<String> agenda;


  Meeting( {required super.name, required super.description,required  this.Director,required  this.agenda
   ,required super.id,
   required super.ActivityBeginDate, required super.ActivityEndDate, required super.ActivityAdress, required super.ActivityPoints,
   required super.categorie, required super.IsPaid, required super.price, required super.Participants, required super.CoverImages, });
}