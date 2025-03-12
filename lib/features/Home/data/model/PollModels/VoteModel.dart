import 'package:jci_app/features/Home/domain/entities/poll/Vote.dart';

class VoteModel extends Vote{
  VoteModel({required super.userId, required super.userImage});
  /// Create a `VoteModel` from a JSON map
  factory VoteModel.fromJson(Map<Object?, Object?> json) {
    return VoteModel(
      userId: json['userId'] as String,
      userImage: json['userImage'] as String,
    );
  }
///from entity

  factory VoteModel.fromEntity(Vote vote)
  {
    return VoteModel(userId: vote.userId, userImage: vote.userImage);
  }

  /// Convert the `VoteModel` to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userImage': userImage,
    };
  }
}