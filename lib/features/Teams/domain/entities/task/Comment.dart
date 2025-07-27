import '../../../../../core/PrimitiveUser/User.dart';

class Comment{
  final String TaskId;
  final String comment;
  final User Member;
  final String Id;
  final DateTime CreatedAt;

  Comment({
    required this.TaskId,
    required this.comment,
    required this.Member,
    required this.Id,
    required this.CreatedAt,
  });


}