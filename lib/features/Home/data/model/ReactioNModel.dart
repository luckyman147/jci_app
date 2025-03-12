import 'package:jci_app/features/Home/domain/entities/Note.dart';

class ReactionModel extends Reaction{
  ReactionModel( {required super.ActivityId,required super.reaction, required super.numberOfUsers, required super.users});

//to json
  Map<String, dynamic> toJson() {
    return {
      "ActivityId": ActivityId,
      'reaction': reaction,
      'numberOfUsers': numberOfUsers,
      "users": users,
    };
  }

  //from json
  factory ReactionModel.fromJson(Map<Object?, Object?> json) {
    // Safely convert the map to Map<String, dynamic>
    final Map<String, dynamic> mappedJson = json.map(
          (key, value) => MapEntry(key.toString(), value),
    );

    return ReactionModel(
      ActivityId: mappedJson['ActivityId'] as String,
      reaction: mappedJson['reaction'] as String,
      numberOfUsers: mappedJson['numberOfUsers'] as int,
      users: (mappedJson['users'] as List<Object?>).map((e) => e as String).toList(),

    );
  }
  factory ReactionModel.fromEntity(Reaction reaction) {
    return ReactionModel(
      ActivityId: reaction.ActivityId,
      users: reaction.users,
      reaction: reaction.reaction,
      numberOfUsers: reaction.numberOfUsers,
    );
  }
}