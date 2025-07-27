import 'package:equatable/equatable.dart';

import 'PollOption.dart';

class Poll extends Equatable {
  final String id;
  final String title;
final String ActivityId;
  final List<PollOptions> options;
  final DateTime createdAt;
  final bool isTemplate;

  const Poll({ required this.ActivityId, required this.id, required this.title, required this.options, required this.createdAt, this.isTemplate=false});




  @override
  List<Object?> get props => [id, title, options,ActivityId,createdAt];
}