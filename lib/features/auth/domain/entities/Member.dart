import 'package:equatable/equatable.dart';

class Member extends Equatable {
  const Member(this.id);

  final String id;

  @override
  List<Object> get props => [id];

  static const empty = Member('-');
}
