import 'package:jci_app/features/Teams/data/models/TaskModel.dart';
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
  final List<Tasks> tasks;
  Team.empty() : this(id: '', name: '', TeamLeader: null, description: '', event: null, status: false, Members: [], CoverImage: '', tasks: []);

  //is empty
  bool get isEmpty => id.isEmpty && name.isEmpty && TeamLeader == null && description.isEmpty && event == null && status == false && Members.isEmpty && CoverImage.isEmpty && tasks.isEmpty;

  //tojson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'TeamLeader': TeamLeader,
      'description': description,
      'event': event,
      'status': status,
      'Members': Members,
      'CoverImage': CoverImage,
      'tasks': tasks.map((e) => e.toJson()).toList(),
    };
  }
  //fromjson
  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      TeamLeader: json['TeamLeader'],
      description: json['description'],
      event: json['event'],
      status: json['status'],
      Members: json['Members'],
      CoverImage: json['CoverImage'] as String,
      tasks: json['tasks'].map<TaskModel>((e) => TaskModel.fromJson(e)).toList(),
    );
  }
  @override
  String toString() {
    return 'Team{id: $id, name: $name, TeamLeader: $TeamLeader, description: $description, '
        'event: $event, status: $status, Members: $Members, CoverImage: $CoverImage, tasks: $tasks}';
  }
  Team( {required this.name,
  required this.id,
required this.TeamLeader,

    required this.description,
     required this.status,
    
     required this.event, required this.Members, required this.CoverImage, required this.tasks});
}
