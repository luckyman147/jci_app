import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Home/domain/Dtos/PollDto.dart';

import '../entities/poll/Poll.dart';

abstract class PollRepository {
  Future<Either<Failure,Unit>> createPoll(Poll poll);

  Stream<Either<Failure,List<Poll>>> getPollAsStream(String activityId);
  Future<Either<Failure,List<Poll>>> GetPollAsTemplates();

Future<Either<Failure,Unit>>  addOption(PollDto polldtoPolldto, );

Future<Either<Failure,Unit>>  updateOption(PollDto polldto,);

Future<Either<Failure,Unit>>  updateVote(PollDto polldto,);

Future<Either<Failure,Unit>>  deletePoll(PollDto polldto,);

Future<Either<Failure,Unit>>  deleteOption(PollDto polldto,);
Future<Either<Failure,Unit>>  SaveToTemplate(Poll poll,);



}
