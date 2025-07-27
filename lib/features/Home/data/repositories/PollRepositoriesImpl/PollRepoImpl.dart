import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Home/data/datasources/Polls/PollRemoteDataSource.dart';
import 'package:jci_app/features/Home/data/model/PollModels/PollOptionModel.dart';
import 'package:jci_app/features/Home/domain/Dtos/PollDto.dart';
import 'package:jci_app/features/Home/domain/entities/poll/Poll.dart';
import 'package:jci_app/features/Home/domain/repsotories/PollRepositories.dart';

import '../../model/PollModels/PollModel.dart';

class PollRepoImpl implements PollRepository{
  final PollRemoteDataSource pollRemoteDataSource;
  final Handler<Unit> Unithandler;
  final Handler<List<Poll>> handler;

  PollRepoImpl(this.Unithandler, {required this.pollRemoteDataSource, required this.handler});
  @override
  Future<Either<Failure, Unit>> addOption(PollDto polldtoPolldto)async {
    return await Unithandler.handle(
        onCall: (){
          final pollOptionModel = PollOptionModel.fromEntity( polldtoPolldto.pollOption!);
          return pollRemoteDataSource.addOption(polldtoPolldto.ActivityId, polldtoPolldto.Pollid, pollOptionModel);
        },
        onError: (e){
          if (e is Exception) {
            return e.get_failure;
          }
          throw e;

        });
  }

  @override
  Future<Either<Failure, Unit>> createPoll(Poll poll) async{
    return await Unithandler.handle(
        onCall: (){
          final pollModel = PollModel.fromEntity(poll);
          if (pollModel.isTemplate) {
          pollRemoteDataSource.createPollAsTemplate(pollModel);

          }

          return pollRemoteDataSource.createPoll(pollModel);
        },
        onError: (e){
          if (e is Exception) {
            return e.get_failure;
          }
          throw e;

        });
  }

  @override
  Future<Either<Failure, Unit>> deleteOption(PollDto polldto)async{
    return await Unithandler.handle(
        onCall: (){
          return pollRemoteDataSource.deleteOption(polldto);
        },
        onError: (e){
          if (e is Exception) {
            return e.get_failure;
          }
          throw e;

        });
  }

  @override
  Future<Either<Failure, Unit>> deletePoll(PollDto polldto) async{
    return await Unithandler.handle(
        onCall: (){
          return pollRemoteDataSource.deletePoll(polldto);
        },
        onError: (e){
          if (e is Exception) {
            return e.get_failure;
          }
          throw e;

        });
  }

  @override
  Stream<Either<Failure, List<Poll>>> getPollAsStream(String activityId)async* {
    yield* handler.handleSTream(
        onCall: (){
          return pollRemoteDataSource.getPollAsStream(activityId);
        },
        onError: (e){
          if (e is Exception) {
            return e.get_failure;
          }
          throw e;

        });
  }

  @override
  Future<Either<Failure, Unit>> updateOption(PollDto polldto) {
    // TODO: implement updateOption
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateVote(PollDto polldto) async{
    return await Unithandler.handle(
        onCall: (){
          return pollRemoteDataSource.updateVote(polldto.ActivityId, polldto.Pollid, polldto.options!.map((e) => PollOptionModel.fromEntity(e)).toList());
        },
        onError: (e){
          if (e is Exception) {
            return e.get_failure;
          }
          throw e;

        });
  }

  @override
  Future<Either<Failure, List<Poll>>> GetPollAsTemplates() async{
    return await handler.handle(
        onCall: (){
          return pollRemoteDataSource.getPollsAsTemplates();
        },
        onError: (e){
          if (e is Exception) {
            return e.get_failure;
          }
          throw e;

        });

  }

  @override
  Future<Either<Failure, Unit>> SaveToTemplate(Poll poll)async {
    return await Unithandler.handle(
        onCall: (){
          final pollModel = PollModel.fromEntity(poll);
          return pollRemoteDataSource.createPollAsTemplate(pollModel);
        },
        onError: (e){
          if (e is Exception) {
            return e.get_failure;
          }
          throw e;

        });
  }
  
}