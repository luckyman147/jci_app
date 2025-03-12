import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/model/PollModels/PollModel.dart';
import 'package:jci_app/features/Home/data/model/PollModels/PollOptionModel.dart';

import '../../../../auth/AuthWidgetGlobal.dart';
import '../../../domain/Dtos/PollDto.dart';

abstract class PollRemoteDataSource {
  Future<Unit> createPoll(PollModel poll);
  Future<Unit> createPollAsTemplate(PollModel poll);
  Future<Unit> updateVote(String activityId, String pollId, List<PollOptionModel> selectedOptionIds);
  Stream<List<PollModel>> getPollAsStream(String activityId);
  Future<List<PollModel>> getPollsAsTemplates();

  Future<Unit> addOption(String ActivityId, String PollId,PollOptionModel pollOptionModel);

  Future<Unit> updateOption(PollDto polldto,);


  Future<Unit> deletePoll(PollDto polldto,);

  Future<Unit> deleteOption(PollDto polldto,);
}

class PollRemoteDataSourceImpl implements PollRemoteDataSource{
  final FirebaseDatabase databaseReference;
  final FirebaseFirestore firestore;
  final Logger logger ;

  PollRemoteDataSourceImpl({required this.databaseReference, required this.logger, required this.firestore});
  @override
  Future<Unit> addOption(String ActivityId, String PollId,PollOptionModel pollOptionModel) async{
    try {
      await databaseReference.ref("Polls").child(ActivityId).child(PollId).child('options'). child(pollOptionModel.id). push().set(pollOptionModel.toJson());
      return unit;
    } catch (e) {
      logger.e(e);
      rethrow;
    }


  }

  @override
  Future<Unit> createPoll(PollModel poll)async {
    try {
      await databaseReference.ref("Polls").child(poll.ActivityId).child(poll.id).set(poll.toJson());
      return unit;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<Unit> deleteOption(PollDto polldto) async{
    try {
      await databaseReference.ref("Polls").child(polldto.ActivityId).child(polldto.Pollid).child('options').child(polldto .pollOption!.id).remove();
      return unit;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<Unit> deletePoll(PollDto polldto) async{
    try {
      await databaseReference.ref("Polls").child(polldto.ActivityId).child(polldto.Pollid).remove();
      return unit;
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Stream<List<PollModel>> getPollAsStream(String activityId) async*{
    try {
      final ref = databaseReference.ref("Polls").child(activityId);
      yield*  ref.onValue.map((event) {
        final dataSnapshot = event.snapshot.value;

        // Log the raw data for debugging

        if (dataSnapshot == null) {
          return []; // No comments available
        }

        // Ensure the data is a Map
        final rawValue = dataSnapshot as Map<Object?, Object?>;

        if (rawValue.isEmpty) {
          return []; // No comments available
        }

        // Map the entries to ActivityCommentModel instances
        final data = rawValue.entries.map((entry) {
          final polData = entry.value as Map<Object?, Object?>;

          return PollModel.fromJson(polData);
        }).toList();


        // Return the data (most recent first)
        return data;
      });
    } catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<Unit> updateOption(PollDto polldto) async{
    // TODO: implement updateOption
    throw UnimplementedError();
  }

  @override
  Future<Unit> updateVote(String activityId, String pollId, List<PollOptionModel> selectedOptionIds) async{
    try {

      for (var options in selectedOptionIds) {
        await databaseReference
            .ref('Polls')
            .child(activityId)
            .child(pollId)
            .child('options')
            .child(options.id).set(options.toJson());

      }
      return unit;
    } on Exception catch (e) {
      logger.e(e);
      throw ServerException();
      // TODO
    }
  }

  @override
  Future<Unit> createPollAsTemplate(PollModel poll) async{
    /// TODO: implement createPollAsTemplate in the firestore
    try{
      await firestore.collection("Polls").doc(poll.id).set(poll.toJson());
      return unit;
    }catch(e){
      logger.e(e);
      throw ServerException();
    }

  }

  @override
  Future<List<PollModel>> getPollsAsTemplates() async{
    try{
      final snapshot = await firestore.collection("Polls").get();
      return snapshot.docs.map((e) => PollModel.fromJson(e.data())).toList();
    }catch(e){
      logger.e(e);
      throw NotFoundException();
    }

  }
}