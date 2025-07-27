import 'package:jci_app/features/Home/domain/entities/poll/Poll.dart';
import 'package:jci_app/features/Home/domain/entities/poll/PollOption.dart';

import 'PollOptionModel.dart';

class PollModel extends Poll{
  PollModel({required super.ActivityId, required super.id, required super.title, required super.options, required super.createdAt,super.isTemplate=false});


  factory PollModel.fromJson( Map<Object?, Object?> json) {


    final options = (json['options'] as Map<Object?, Object?>)
        .entries
        .map((entry) => PollOptionModel.fromJson(entry.key as String, entry.value as Map<Object?, Object?>))
        .toList();

    return PollModel(
      isTemplate: json['isTemplate'] as bool? ?? false,
      ActivityId: json['ActivityId'] as String,
      id: json['id'] as String,
      title: json['title'] as String,
      options: options, createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert the `PollModel` to a JSON map
  Map<String, dynamic> toJson() {
    final optionsMap = {
      for (PollOptions option in options) option.id:PollOptionModel.fromEntity(option) .toJson(),
    };
    return {
      "createdAt":createdAt.toIso8601String(),
      "ActivityId":ActivityId,
      "id":id,
      "isTemplate":isTemplate,
      'title': title,
      'options': optionsMap,
    };
  }

  factory PollModel.fromEntity(Poll poll)
  {
    return PollModel(ActivityId: poll.ActivityId, id: poll.id, title: poll.title, options: poll.options, createdAt: poll.createdAt,isTemplate:poll.isTemplate);
  }



}