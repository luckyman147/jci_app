import 'package:equatable/equatable.dart';

class Agenda extends Equatable {
  final String title;
  final int endTime;

  final String status ;

  const Agenda({
    required this.title,
    required this.endTime,

    this.status = "Not Started"
  });

  @override
  List<Object?> get props => [title, endTime, status];
}