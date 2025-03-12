
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/strings/Mails.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../../core/error/Exception.dart';
import '../../../model/ActivityGuestsModel.dart';
import '../../../model/GuestModel.dart';

abstract class GuestRemoteDataSources{


  Future<Unit> addGuest(String activityId, GuestModel guest) ;

  Future<Unit>  deleteGuest(String activityId, String guestId) ;

  Future<Unit> updateGuest(String activityId, GuestModel guest) ;

  Future<Unit> updateGuestStatus(String activityId, String guestid, String status) ;

  Future<List<ActivityguestModel>>    getAllGuestOfACtivity(String activityId) ;
  Future<List<GuestModel>>    getAllGuest() ;

  Future<Unit> addGuestToActivity(String activityId, String guestId) ;

  Future<Unit> changeGuestToMember(String guestId) ;
}
class GuestRemoteDataSourcesImpl implements GuestRemoteDataSources{
  final FirebaseFirestore firabaseFireStore;
   final Logger logger;

  GuestRemoteDataSourcesImpl({required this.firabaseFireStore, required this.logger});
  @override
  Future<Unit> addGuest(String activityId, GuestModel guest)async {
try{
  // Check if the guest already exists
  logger.i("Adding guest to activity",activityId);


  final guestQuery = await firabaseFireStore.collection('guests').where('email', isEqualTo: guest.email).get();
  if (guestQuery.docs.isNotEmpty) {
    throw Exception("Guest already exists");
  }

  // Add guest
  final guestRef = firabaseFireStore.collection('guests').doc();
  await guestRef.set(guest.toJson());

 //update id
  await guestRef.update({'id': guestRef.id});

  // Add guest to activity
  final activityRef =  firabaseFireStore.collection('activities').doc(activityId).collection('guests').doc(guestRef.id);
  await activityRef.set({
  "guest":guest.toJson(),
    "status":"Pending"
  });
  logger.i("Guest added successfully to the activity");

  return unit;



}
catch (e) {
  logger.e("Error adding guest to activity: $e");
  throw ServerException();
}
  }

  @override
  Future<Unit> addGuestToActivity(String activityId, String guestId)async {

    try {
      // Fetch guest document
      final guestDoc = await firabaseFireStore.collection('guests').doc(guestId).get();
      if (!guestDoc.exists) {
    throw NotFoundException();
      }

      // Fetch activity document
      final activityRef = firabaseFireStore.collection('activities').doc(activityId);
      final activityDoc = await activityRef.get();
      if (!activityDoc.exists) {
        throw NotFoundException();
      }

      // Check if guest already exists in the activity's guests subcollection
      final guestInActivity = await activityRef
          .collection('guests')
          .doc(guestId)
          .get();

      if (guestInActivity.exists) {
     throw AlreadyParticipateException();
      }
final guest=GuestModel.fromJson(guestDoc.data()!);
      final actGuest=ActivityguestModel(guest: guest,status: "Pending");
      // Add the guest to the activity's guests subcollection
      await activityRef.collection('guests').doc(guestId).set(
        actGuest.toMap());

      if (activityDoc.exists && activityDoc.data() != null) {

        logger.i("Event retrieved successfully with ID: $activityId");
        _createEmailRequest(guest.email, "JCI Hs ", "Bienvenue ${guest.name}", mails.welcomeGuestInFrench(guest.name, activityDoc.data()!['name'],DateTime.parse( activityDoc.data()!["ActivityBeginDate"]), activityDoc.data()!["ActivityAdress"]));
        logger.i("Email sent to guest");
        // Proceed with using 'ev'
      } else {
        logger.e("Document does not exist or contains no data.");
        throw NotFoundException();
      }
      return unit;
    } catch (error) {
      logger.e("Error adding guest to activity: $error");
      rethrow;
    }
  }

  @override
  Future<Unit> changeGuestToMember(String guestId) {
    // TODO: implement changeGuestToMember
    throw UnimplementedError();
  }

  @override
  Future<Unit> deleteGuest(String activityId, String guestId) async{
    await firabaseFireStore.collection('guests').doc(guestId).delete();

    // Remove reference from the activity
    final activityRef = firabaseFireStore.collection('activities').doc(activityId).collection('guests').doc(guestId);
    await activityRef.delete();
    return unit;
  }

  @override
  Future<List<GuestModel>> getAllGuest()async {
    try {
      logger.d("hey ther");
      final snapshot = await firabaseFireStore.collection('guests').get();

      final guests = snapshot.docs.map((doc) {
        return GuestModel.fromJson(doc.data());
      }).toList();
      return guests;
    } catch (error) {
      logger.e("Error fetching guests: $error");
      throw ServerException();
    }
  }

  @override
  Future<List<ActivityguestModel>> getAllGuestOfACtivity(String activityId) async{
    // TODO: implement getAllGuestOfACtivity

    try {
      final snapshot = await firabaseFireStore.collection('activities').doc(activityId).collection('guests').get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
logger.i("Guests fetched successfully");
      final guests = snapshot.docs.map((doc) {
        return ActivityguestModel. fromJson(doc.data());
      }).toList();
      return guests;
    } catch (error) {
      logger.e("Error fetching guests: $error");
      throw ServerException();
    }
  }

  Future<DocumentReference> _createEmailRequest(String email, String text,String subject,String html) async {
    return await firabaseFireStore.collection('mail').add({
      'to': [email],
      'message': {
        'text': text,
        'subject': subject,
        'html': html,
      },
    });
  }


  @override
  Future<Unit> updateGuest(String activityId, GuestModel guest) async{
    try {
      await firabaseFireStore.collection('guests').doc(guest.id).update(guest.toJson());
      return unit;
    } on Exception catch (e) {
      logger.e("Error updating guest: $e");
      throw ServerException();
      // TODO
    }
  }

  @override
  Future<Unit> updateGuestStatus(String activityId, String guestid, String status) async{

    // Update the guest status in the activity's guests subcollection
    final guestRef = firabaseFireStore.collection('activities').doc(activityId).collection('guests').doc(guestid);
    await guestRef.update({
      'status': status,
    });
    return unit;
  }
}
