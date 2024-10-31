import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/about_jci/Domain/Repository/BoardRepo.dart';

import '../entities/BoardRole.dart';
import '../entities/BoardYear.dart';

class getYearsUseCase extends UseCase<List<String>, NoParams> {
  final BoardRepo boardRepo;

  getYearsUseCase({required this.boardRepo});

  @override
  Future<Either<Failure, List<String>>> call(NoParams params) async {
    return await boardRepo.getYears();
  }

}
class GetBoardByYearUseCase extends UseCase<BoardYear, String> {
  final BoardRepo boardRepo;

  GetBoardByYearUseCase({required this.boardRepo});
  @override
  Future<Either<Failure, BoardYear>> call(String year)async {
    return await boardRepo.getBoardByYear(year);
  }
}
class AddBoardUseCase extends UseCase<Unit, String> {
  final BoardRepo boardRepo;

  AddBoardUseCase({required this.boardRepo});
  @override
  Future<Either<Failure, Unit>> call(String year)async {
    return await boardRepo.AddBoard(year);
  }
}
class RemoveBoardUseCase extends UseCase <Unit, String> {
  final BoardRepo boardRepo;

  RemoveBoardUseCase({required this.boardRepo});
  @override
  Future<Either<Failure, Unit>> call(String year)async {
    return await boardRepo.RemoveBoard(year);
  }
}
class getBoardRolesUseCase extends UseCase<List<BoardRole>, int> {
  final BoardRepo boardRepo;

  getBoardRolesUseCase({required this.boardRepo});
  @override
  Future<Either<Failure, List<BoardRole>>> call(int priority)async {
    return await boardRepo.getBoardRoles(priority);
  }
}
class AddPositionUseCase extends UseCase<Unit, PostField> {
  final BoardRepo boardRepo;


  AddPositionUseCase({required this.boardRepo});
  @override
  Future<Either<Failure, Unit>> call(PostField post)async {
    return await boardRepo.AddPositionInBoard( post.year, post.role);
  }
}
class AddMemberBoardUseCase extends UseCase<Unit, PostField> {
  final BoardRepo boardRepo;

  AddMemberBoardUseCase({required this.boardRepo});
  @override
  Future<Either<Failure, Unit>> call(PostField post)async {
    return await boardRepo.AddMemberBoard(post.id!, post.assignTo!);
  }
}
class RemoveMemberBoardUseCase extends UseCase<Unit, PostField> {
  final BoardRepo boardRepo;

  RemoveMemberBoardUseCase({required this.boardRepo});
  @override
  Future<Either<Failure, Unit>> call(PostField post)async {
    return await boardRepo.RemoveMemberBoard(post.id!, post.assignTo!);
  }
}
class RemovePositionUseCase extends UseCase<Unit, PostField> {
  final BoardRepo boardRepo;

  RemovePositionUseCase({required this.boardRepo});
  @override
  Future<Either<Failure, Unit>> call(PostField post)async {
    return await boardRepo.RemovePositionInBoard(post.id!, post.year);
  }
}
class AddRoleUseCase extends UseCase<Unit, BoardRole> {
  final BoardRepo boardRepo;

  AddRoleUseCase({required this.boardRepo});
  @override
  Future<Either<Failure, Unit>> call(BoardRole role)async {
    return await boardRepo.AddBoardRole(role);
  }
}
 class RemoveRoleUseCase extends UseCase<Unit, String> {
  final BoardRepo boardRepo;

  RemoveRoleUseCase({required this.boardRepo});
  @override
  Future<Either<Failure, Unit>> call(String roleId)async {
    return await boardRepo.RemoveBoardRole(roleId);
  }}


class PostField {
  final String year;
  final String role;
  final String? assignTo;
  final String? id;

  PostField({required this.year, required this.role, required this.assignTo, required this.id});

}
