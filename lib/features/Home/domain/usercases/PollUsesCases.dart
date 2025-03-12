import 'package:dartz/dartz.dart';

import '../../../../core/error/Failure.dart';
import '../../../../core/usescases/usecase.dart';
import '../Dtos/PollDto.dart';
import '../entities/poll/Poll.dart';
import '../repsotories/PollRepositories.dart';

class GetPollsOfActivityUseCase{
  final PollRepository repository;

  GetPollsOfActivityUseCase(this.repository);


  Stream<Either<Failure, List<Poll>>> call(String params) async* {
    yield*  repository.getPollAsStream(params);
  }
}
class CreatePollUseCase extends UseCase<Unit,Poll> {
  final PollRepository repository;

  CreatePollUseCase(this.repository);

  @override
  Future<Either<Failure,Unit>> call(Poll poll) async {
    return await repository.createPoll(poll);
  }
}
class AddOptionUseCase extends UseCase<Unit,PollDto> {
  final PollRepository repository;

  AddOptionUseCase(this.repository);

  @override
  Future<Either<Failure,Unit>> call(PollDto polldto) async {
    return await repository.addOption(polldto);
  }
}
class UpdateOption extends UseCase<Unit,PollDto> {
  final PollRepository repository;

  UpdateOption(this.repository);

  @override
  Future<Either<Failure,Unit>> call(PollDto polldto) async {
    return await repository.updateOption(polldto);
  }
}
class UpdateVote extends UseCase<Unit,PollDto> {
  final PollRepository repository;

  UpdateVote(this.repository);

  @override
  Future<Either<Failure,Unit>> call(PollDto polldto) async {
    return await repository.updateVote(polldto);
  }
}
class DeletePollUseCase extends UseCase<Unit,PollDto> {
  final PollRepository repository;

  DeletePollUseCase(this.repository);

  @override
  Future<Either<Failure,Unit>> call(PollDto polldto) async {
    return await repository.deletePoll(polldto);
  }
} class GetPollAsTemplatesUseCase extends UseCase<List<Poll>,NoParams> {
  final PollRepository repository;

  GetPollAsTemplatesUseCase(this.repository);

  @override
  Future<Either<Failure,List<Poll>>> call(NoParams param) async {
    return await repository.GetPollAsTemplates();
  }
}