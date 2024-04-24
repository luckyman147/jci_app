import '../../../auth/domain/entities/Member.dart';

class Post{
  final String id;
  final String boardRoleId;
  final String role;
  final List<Member> assignTo;

  Post({required this.id, required this.boardRoleId, required this.role, required this.assignTo});

}