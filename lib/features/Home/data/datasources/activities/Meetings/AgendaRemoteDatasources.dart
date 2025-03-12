import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/domain/entities/Agenda.dart';
import 'package:logger/logger.dart';

import '../../../../../../core/config/env/urls.dart';
import '../../../../../../core/error/Exception.dart';
import '../../../model/meetingModel/AgendaModel.dart';
import 'package:http/http.dart' as http;
abstract class AgendaRemoteDataSource{
  Future<Unit> StartMeeting(String ActivityId,List<AgendaModel> agendas

      );

  Future<Unit> checkAndUpdateActivityStatus(String activityId);
  Future<Unit> updateCurrentPoint(String activityId);
  /// Checks if all points in the activity are completed.
  Future<bool> areAllPointsCompleted(String activityId);
  /// Starts the next point in the agenda.
  Future<Unit> startNextPoint(String activityId,List <AgendaModel> agendas);
  Future<Unit> SendNotifications(String ActivityId,AgendaModel agenda1);

  Future<Unit> UpdateMeetingStatus(String activityId,String status);
Future<AgendaModel> FetchAgendas(String ActivtyId);

}
class AgendaRemoteDataSourceImpl implements AgendaRemoteDataSource {
  final FirebaseFirestore firestore;

  AgendaRemoteDataSourceImpl({required this.firestore});
  

  @override
  Future<Unit> SendNotifications(String ActivityId, AgendaModel agenda1) async{
    try{
      final ExpiryTime = DateTime.now().add(Duration(minutes: agenda1.endTime));
      final url = '${Urls.mainurl}/notifyAgendaPoint?activityId=$ActivityId&pointName=${agenda1.title} &ExpiryDate=$ExpiryTime';
      final response = await http.post(Uri.parse(url));
      if (response.statusCode == 200) {
        Logger().i('kalba: $response');
        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      } else {
        Logger().e ('hastah: ${response.body}');
        throw NotVerifiedException();
      }


    } catch (e) {
      Logger().e('sdss: $e');
      throw ServerException();
    }



  }
  @override
  Future<Unit> StartMeeting(String activityId, List<AgendaModel> agendas) async {
    try {
      final activityDoc = firestore.collection('activities').doc(activityId);
      final agendaCollection = activityDoc.collection('agenda');

      // Create or get the agenda document
      DocumentReference agendaDocRef = await _getOrCreateAgendaDocument(agendaCollection, agendas);

      // Update the first point's status to "In Progress"
      await agendaDocRef.update({
        'points.0.status': 'In Progress',
        'points.0.startTime': DateTime.now(),
        'points.0.endTime': DateTime.now().add(Duration(minutes: agendas[0].endTime)),
      });

      // Update the activity document to reflect that the meeting has started
      await activityDoc.update({
        'status': 'In Progress',
        'CurrentIndex': 0,
      });

      return unit;
    } catch (e) {
      Logger().e(e.toString());
     rethrow  ;
    }
  }

  Future<DocumentReference> _getOrCreateAgendaDocument(CollectionReference agendaCollection, List<AgendaModel> agendas) async {
    // Check if the agenda document already exists
    final querySnapshot = await agendaCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first
          .reference; // Return existing document reference
    } else {
      // Create a new document with all points
      final newAgendaDocRef = await agendaCollection.add({
        'points': agendas.map((agenda) =>
        {
          'title': agenda.title,
          'status': 'Pending', // Default status for new points
          'duration': agenda.endTime,
        }).toList(),
      });
      return newAgendaDocRef; // Return the reference to the newly created document
    }
  }

  @override
  Future<bool> areAllPointsCompleted(String activityId) async{
    final activityDoc = firestore.collection('activities').doc(activityId);
    final agendaCollection = activityDoc.collection('agenda');

    // Assuming only one agenda document exists within the collection
    final agendaDocSnapshot = await agendaCollection.get().then((querySnapshot) => querySnapshot.docs.first);

    // Get the points data
    final pointsData = agendaDocSnapshot.data()['points'] as List<dynamic>;

    // Check if all points are marked as 'Completed'
    return pointsData.every((point) => point['status'] == 'Completed');
  }
  @override
  Future<Unit> updateCurrentPoint(String activityId)async {
    final activityDoc = firestore.collection('activities').doc(activityId);
    final agendaCollection = activityDoc.collection('agenda');

    // Assuming only one agenda document exists within the collection
    final agendaDocSnapshot = await agendaCollection.get().then((querySnapshot) => querySnapshot.docs.first);
    final agendaDocRef = agendaDocSnapshot.reference;

    final currentPointIndex = (await activityDoc.get()).data()!['CurrentIndex'];

    await agendaDocRef.update({
      'points.$currentPointIndex.status': 'Completed',
    });

    await activityDoc.update({
      'CurrentIndex':
      currentPointIndex + 1 < agendaDocSnapshot.data()['points'].length
          ? currentPointIndex + 1
          : currentPointIndex,
    });
    return unit;
  }
  @override


  Future<Unit> startNextPoint(String activityId,List<AgendaModel> agendas) async {
    final activityDoc = firestore.collection('activities').doc(activityId);
    final agendaCollection = activityDoc.collection('agenda');

    // Assuming only one agenda document exists within the collection
    final agendaDocSnapshot = await agendaCollection.get().then((querySnapshot) => querySnapshot.docs.first);
    final agendaDocRef = agendaDocSnapshot.reference;

    final currentPointIndex = (await activityDoc.get()).data()!['currentPointIndex'];

    // Start the next point if it exists
    if (currentPointIndex + 1 < agendaDocSnapshot.data()['points'].length) {
      await _startNextPoint(agendaDocRef, currentPointIndex + 1, agendaDocSnapshot,agendas);
      return unit;
    } else {
      // Check if all points are completed before updating the status
      await checkAndUpdateActivityStatus(activityId);
      Logger().i('All points are completed');
      return unit;
    }
  }

  Future<void> _startNextPoint(DocumentReference agendaDocRef, int nextPointIndex, DocumentSnapshot agendaDocSnapshot,List<AgendaModel> agendas) async {
    await agendaDocRef.update({
      'points.$nextPointIndex.status': 'In Progress',
      'points.$nextPointIndex.startTime': DateTime.now(),
      'points.$nextPointIndex.endTime':
      DateTime.now() .add(
          Duration(minutes: agendas[nextPointIndex].endTime)),
    });
  }
@override
  Future<Unit> checkAndUpdateActivityStatus(String activityId) async {
    if (await areAllPointsCompleted(activityId)) {
      final activityDoc = firestore.collection('activities').doc(activityId);
      await activityDoc.update({
        'status': 'Completed',
        "CurrentIndex":-1
      });
      return unit;
    }

    else {
      Logger().i('Not all points are completed');
      return unit;}
  }

  @override
  Future<Unit> UpdateMeetingStatus(String activityId,String status) async {
    try {
      final activityDoc = firestore.collection('activities').doc(activityId);
      final agendaCollection = activityDoc.collection('agenda');

      // Assuming only one agenda document exists within the collection
      final agendaDocSnapshot = await agendaCollection.get().then((querySnapshot) => querySnapshot.docs.first);
      final agendaDocRef = agendaDocSnapshot.reference;

      final currentPointIndex = (await activityDoc.get()).data()!['CurrentIndex'];

      // Update current point's status to "Paused"
      await agendaDocRef.update({
        'points.$currentPointIndex.status': status,
      });

      // Update meeting status to "Paused"
      await activityDoc.update({
        'status': status,
      });

      Logger().i('Meeting paused and current point is now paused.');

      return unit;

    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AgendaModel> FetchAgendas(String ActivtyId) {
    // TODO: implement FetchAgendas
    throw UnimplementedError();
  }


  
}