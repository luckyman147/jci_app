import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/about_jci/Domain/entities/BoardYear.dart';

import '../entities/BoardRole.dart';
import '../entities/Post.dart';

abstract class BoardRepo {
  //getters
  Future<Either<Failure,List<String>>> getYears();
  Future<Either<Failure,BoardYear>> getBoardByYear(String year);
Future<Either<Failure,List<BoardRole>>> getBoardRoles(int priority);
Future<Either<Failure,Unit>> AddPositionInBoard(String year,String role);
Future<Either<Failure,Unit>> RemovePositionInBoard(String postId,String year);

//post
  Future<Either<Failure,Unit>> AddMemberBoard(String year,String memberId);
Future<Either<Failure,Unit>> RemoveMemberBoard(String year,String memberId);

Future<Either<Failure,Unit>> AddBoardRole(BoardRole boardRole);
Future<Either<Failure,Unit>> RemoveBoardRole(String roleId);
Future<Either<Failure,Unit>> AddBoard(String year);
Future<Either<Failure,Unit>> RemoveBoard(String year);

}