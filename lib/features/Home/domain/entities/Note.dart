import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String title;
  final String id;
  final String content;
  final DateTime date;
  final dynamic owner;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.owner,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [title, content, date, owner];
}
