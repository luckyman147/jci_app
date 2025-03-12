import 'package:equatable/equatable.dart';

class Vote extends Equatable {
  final String userId;
  final String userImage;

  const Vote({required this.userId, required this.userImage});

  @override
  // TODO: implement props
  List<Object?> get props => [userId, userImage];
}