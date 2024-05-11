import 'package:equatable/equatable.dart';

import 'Guest.dart';

class ActivityGuest extends Equatable{

  final Guest guest;

  final String status;

  ActivityGuest({required this.guest, required this.status});

  @override
  // TODO: implement props
  List<Object?> get props => [guest,status];
}