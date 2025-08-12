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
  Agenda copyWith({
    String? title,
    int? endTime,
    String? status,
  }) {
    return Agenda(
      title: title ?? this.title,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'endTime': endTime,
      'status': status,
    };
  }
  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      title: json['title'] ?? '',
      endTime: json['endTime'] ?? 0,
      status: json['status'] ?? 'Not Started',
    );
  }
  

  @override
  List<Object?> get props => [title, endTime, status];
}