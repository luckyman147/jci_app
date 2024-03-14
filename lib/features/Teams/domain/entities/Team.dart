import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../Home/domain/entities/Event.dart';
import 'Task.dart';

class Team{
  final String id;
  final String name;
final dynamic TeamLeader;
  final String description;
  final dynamic event;
final bool status;
  final List<dynamic > Members;
  final String CoverImage;
  final List<Map<String,dynamic>> tasks;

  Team( {required this.name,
  required this.id,
required this.TeamLeader,

    required this.description,
     required this.status,
    
     required this.event, required this.Members, required this.CoverImage, required this.tasks});
}