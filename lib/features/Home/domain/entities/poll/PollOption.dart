import 'package:equatable/equatable.dart';

import 'Vote.dart';

class PollOptions extends Equatable {
  final String id;
  final String title;
  final List<Vote> votes;

  const PollOptions({required this.id, required this.title, required this.votes});


  @override
  List<Object?> get props => [id, title, votes];

 PollOptions  copyWith({required List<Vote> voted}) {

    return PollOptions(id: id, title: title, votes: voted);
  }
}
