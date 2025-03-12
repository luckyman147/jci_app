import 'package:jci_app/features/Home/domain/entities/poll/PollOption.dart';

import 'VoteModel.dart';

class PollOptionModel extends PollOptions{
  PollOptionModel({required super.id, required super.title, required super.votes});
  factory PollOptionModel.fromJson(String id, Map<Object?, Object?> json) {
    final votes = json["votes"]!=null? (json['votes'] as List<Object?>)
        .map((entry) => VoteModel.fromJson(entry as Map<Object?, Object?>))
        .toList():<VoteModel>[];
    return PollOptionModel(
      id: id,
      title: json['title'] as String,
      votes: votes,
    );
  }///from entity

  factory PollOptionModel.fromEntity(PollOptions pollOption)
  {
    return PollOptionModel(id: pollOption.id, title: pollOption.title, votes: pollOption.votes);
  }

  /// Convert the `PollOptionModel` to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'votes': votes.map((vote) => VoteModel.fromEntity(vote).toJson()).toList(),
    };
  }

}