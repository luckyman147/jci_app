import '../../../../Home/data/model/events/EventModel.dart';
import '../../../../Home/domain/entities/Activity/event/Event.dart';
import '../../../../Home/domain/entities/Activitys/ActivityBasics.dart';

class TeamMeta {
  final String id;
  final String name;
  final String description;
  final String? projectId;
  final String coverImage;
  final ActivityBasics? event;
  final bool status;

  const TeamMeta({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.status,
    this.projectId,
    this.event,
  });

  TeamMeta copyWith({
    String? id,
    String? name,
    String? description,
    String? projectId,
    String? coverImage,
    ActivityBasics? event,
    bool? status,
  }) {
    return TeamMeta(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      projectId: projectId ?? this.projectId,
      coverImage: coverImage ?? this.coverImage,
      event: event ?? this.event,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'projectId': projectId,
      'coverImage': coverImage,
      'event': event?.toJson(),
      'status': status,
    };
  }

  factory TeamMeta.fromJson(Map<String, dynamic> json) {
    return TeamMeta(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      projectId: json['projectId']?? '',
      coverImage: json['coverImage'] ?? '',
      event: json['event'] != null ? ActivityBasics.fromJson(json['event']) : null,
      status: json['status'] ?? false,
    );
  }
}
