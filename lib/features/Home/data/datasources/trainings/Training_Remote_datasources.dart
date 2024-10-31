import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:jci_app/core/config/env/urls.dart';



import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/verification.dart';
import 'package:jci_app/features/Home/data/model/ActivityParticpantsModel.dart';
import 'package:jci_app/features/Home/data/model/GuestModel.dart';


import '../../../../../core/config/services/MemberStore.dart';
import '../../../../../core/config/services/uploadImage.dart';
import '../../../../../core/error/Exception.dart';

import '../../model/ActivityGuestsModel.dart';
import '../../model/TrainingModel/TrainingModel.dart';
import '../activities/ActivityRemote.dart';

abstract class TrainingRemoteDataSource {
  Future<List<TrainingModel>> getAllTraining();
  Future<TrainingModel> getTrainingById(String id);
  Future<List<TrainingModel>> getTrainingOfTheWeek();
  Future<List<TrainingModel>> getTrainingOfTheMonth();

  Future<Unit> createTraining(TrainingModel Training);
  Future<Unit> updateTraining(TrainingModel Training);
  Future<Unit> deleteTraining(String id);

  Future<Unit> leaveTraining(String id);
  Future<Unit> participateTraining(String id);

 Future<Unit> checkAbsence(String activityId, String memberId, String status) ;

  Future<List<ActivityParticipantsModel>> getAllParticipants(String activityId) ;

  Future<Unit> sendReminder(String activityId) ;

 Future<ActivityguestModel> addGuest(String activityId, GuestModel guest) ;

  Future<Unit>  deleteGuest(String activityId, String guestId) ;

  Future<Unit> updateGuest(String activityId, GuestModel guest) ;

  Future<Unit> updateGuestStatus(String activityId, String guestid, String status) ;

Future<List<ActivityguestModel>>    getAllGuestOfACtivity(String activityId) ;
Future<List<GuestModel>>    getAllGuest() ;

  Future<Unit> addGuestToActivity(String activityId, String guestId) ;

  Future<Unit> changeGuestToMember(String guestId) ;

}

class TrainingRemoteDataSourceImpl implements TrainingRemoteDataSource{
  final http.Client client;

  TrainingRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> createTraining(TrainingModel Training)async {
    final token = await getTokens();
    final body =Training.toJson();
    return client.post(
      Uri.parse(createTrainingUrl),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${token[1]}"},
      body: json.encode(body),
    ).then((response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;

if (Training.CoverImages[0]!=null) {
  final uploadResponse = await uploadImages(
      decodedJson['_id'], Training.CoverImages.first, getTrainingsUrl,
      "CoverImages");
  if (uploadResponse.statusCode == 200) {
    return Future.value(unit);
  }
  else if (uploadResponse.statusCode == 400) {
    debugPrint(uploadResponse.reasonPhrase.toString());
    deleteTraining(decodedJson["_id"]);
    throw EmptyDataException();
  } else {
    throw ServerException();
  }
}
else{
  return Future.value(unit);
}
      }
      else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      }
      else {
        throw ServerException();
      }
    });
  }

  @override
  Future<Unit> deleteTraining(String id) async {
    final token = await getTokens();
    final response = await client.delete(

      Uri.parse("$getTrainingsUrl$id"),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${token[1]}"

      },
    );
    if (response.statusCode==204){
      return Future.value(unit);
    }
    else{
      throw EmptyDataException();
    }
  }

  @override
  Future<List<TrainingModel>> getAllTraining()async  {
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response = await client.post(

      Uri.parse(getTrainingsUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),

    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('Trainings')) {
        final List<TrainingModel> TrainingModels = (decodedJson['Trainings'] as List)
            .map<TrainingModel>((jsonPostModel) =>
            TrainingModel.fromJson(jsonPostModel))
            .toList();

        return TrainingModels;
      } else {
        throw EmptyDataException();
      }
    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<TrainingModel> getTrainingById(String id) async{
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response =  await client.post(
      Uri.parse('${getTrainingsUrl}get/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;

      final TrainingModel trainingModel = TrainingModel.fromJson(decodedJson);
      return trainingModel;

    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<TrainingModel>> getTrainingOfTheMonth() async{
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response =  await client.post(
      Uri.parse(getTrainingByMonth),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),

    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('Trainings')) {
        final List<TrainingModel> TrainingModels = (decodedJson['Trainings'] as List)
            .map<TrainingModel>((jsonTrainingModel) =>
            TrainingModel.fromJson(jsonTrainingModel))
            .toList();

        return TrainingModels;
      } else {
        throw EmptyDataException();
      }
    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }

  }

  @override
  Future<List<TrainingModel>> getTrainingOfTheWeek()async  {
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response = await client.post(

      Uri.parse(getTrainingByWeek),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('Trainings')) {
        final List<TrainingModel> TrainingModels = (decodedJson['Trainings'] as List)
            .map<TrainingModel>((jsonTrainingModel) =>
            TrainingModel.fromJson(jsonTrainingModel))
            .toList();
        print(TrainingModels.first.name);
        return TrainingModels;
      } else {
        throw EmptyDataException();
      }
    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<Unit> leaveTraining(String id) async{
return leaveActivity(id, client, getTrainingsUrl);

  }

  @override
  Future<Unit> participateTraining(String id) async {
return await ParticiActivity(id, client, getTrainingsUrl);
  }

  @override
  Future<Unit> updateTraining(TrainingModel Training) async {
    final body =Training.toJson();
   return await  EditFunction(Training, body, "$getTrainingsUrl${Training.id}/edit", getTrainingsUrl, client);}

  @override
  Future<Unit>  checkAbsence(String activityId, String memberId, String status) async{
    final token = await getTokens();

    return client.patch(
      Uri.parse(Urls.CheckAbsence),
      headers: {"Content-Type": "application/json",
        "Authorization":'Bearer ${token[1]}'

      },

      body: json.encode({

        "activityId": activityId,
        "memberId": memberId,
        "status": status
      }),
    ).then((response) async {

      if (response.statusCode == 200) {

return Future.value(unit);



      }
      else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      }
      else if (response.statusCode==401){
        throw UnauthorizedException();
      }
      else {
        throw ServerException();
      }

    });
  }

  @override
 Future<List<ActivityParticipantsModel>> getAllParticipants(String activityId) {

      return client.get(
        Uri.parse(Urls.getAllParticipants(activityId)),
        headers: {"Content-Type": "application/json",


        },

      ).then((response) async {
        if (response.statusCode == 200) {
          final List<dynamic> decodedJson = json.decode(response.body);

            final List<ActivityParticipantsModel> members = decodedJson
                .map<ActivityParticipantsModel>((jsonMemberModel) =>
                ActivityParticipantsModel.fromJson(jsonMemberModel))
                .toList();
            return members;

        } else if (response.statusCode == 400) {
          throw EmptyDataException();
        }else{
          throw ServerException();
     }
      });
}

  @override
  Future<Unit> sendReminder(String activityId) {

    return client.post(
      Uri.parse(Urls.SendReminderUrl(activityId)),
      headers: {"Content-Type": "application/json",


      },

    ).then((response) async {

      if (response.statusCode == 200) {

        return Future.value(unit);

      }
      else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      }
      else if (response.statusCode==401){
        throw UnauthorizedException();
      }
      else {
        throw ServerException();
      }});

  }

  @override
  Future<ActivityguestModel> addGuest(String activityId, GuestModel guest) async{
    final token = await getTokens();
    return client.post(
      Uri.parse(Urls.Addguest(activityId)),
      headers: {"Content-Type": "application/json",},
      body: json.encode(guest.toJson()),
    ).then((response) async {
      if (response.statusCode == 200) {
        final  decodedJson = json.decode(response.body);

        final ActivityguestModel guests =ActivityguestModel.fromJson(decodedJson);
        return guests;
      } else if (response.statusCode == 400 || response.statusCode==409) {
        throw WrongCredentialsException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException();
      }
    });


  }

  @override
  Future<Unit> deleteGuest(String activityId, String guestId)async {
    final token = await getTokens();
    return client.delete(
      Uri.parse(Urls.deleteguest(activityId, guestId)),
      headers: {"Content-Type": "application/json",
        "Authorization":'Bearer ${token[1]}'
      },
    ).then((response) async {
      if (response.statusCode == 204) {
        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException();
      }
    });

  }

  @override
  Future<Unit> updateGuest(String activityId, GuestModel guest)async {
    final token = await getTokens();
    return client.patch(
      Uri.parse(Urls.Addguest(guest.id)),
      headers: {"Content-Type": "application/json",
        "Authorization":'Bearer ${token[1]}'
      },
      body: json.encode(guest.toJson()),
    ).then((response) async {
      if (response.statusCode == 200) {
        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException();
      }
    });
    }



  @override
  Future<Unit> updateGuestStatus(String activityId, String guestid, String status)async {
    final token = await getTokens();
    return client.patch(
      Uri.parse(Urls.deleteguest(activityId, guestid)),
      headers: {"Content-Type": "application/json",
        "Authorization":'Bearer ${token[1]}'
      },
      body: json.encode({
        "confirmed": status
      }),
    ).then((response) async {
      if (response.statusCode == 200) {
        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException();
      }
    });
  }

  @override
  Future<List<ActivityguestModel>> getAllGuestOfACtivity(String activityId) async{
    final token = await getTokens();
    return client.get(
      Uri.parse(Urls.Addguest(activityId)),
      headers: {"Content-Type": "application/json",
        "Authorization":'Bearer ${token[1]}'
        },
    ).then((response) async {
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body);

        final List<ActivityguestModel> guests = decodedJson
            .map<ActivityguestModel>((jsonGuestModel) =>
            ActivityguestModel.fromJson(jsonGuestModel))
            .toList();
        return guests;
      } else if (response.statusCode == 400) {
        throw EmptyDataException();
      }else{
        throw ServerException();
      }
    });
    }

  @override
  Future<List<GuestModel>> getAllGuest() async {
    final token = await getTokens();
    return client.post(
      Uri.parse(Urls.ALLGuestsAllUrl),
      headers: {"Content-Type": "application/json",
        "Authorization":'Bearer ${token[1]}'
      },
    ).then((response) async {
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body);

        final List<GuestModel> guests = decodedJson
            .map<GuestModel>((jsonGuestModel) =>
            GuestModel.fromJson(jsonGuestModel))
            .toList();
        return guests;
      } else if (response.statusCode == 400) {
        throw EmptyDataException();
      }else{
        throw ServerException();
      }
    });

  }

  @override
  Future<Unit> addGuestToActivity(String activityId, String guestId)async {
    final token =await getTokens();
    return client.post(
      Uri.parse(Urls.AddGuestToActivity(activityId, guestId)),
      headers: {"Content-Type": "application/json",
        "Authorization":'Bearer ${token[1]}'},
    ).then((response) async {
      if (response.statusCode == 200) {
        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException();
      }
    });
    }

  @override
  Future<Unit> changeGuestToMember(String guestId)async {
    final token =await getTokens();
    return client.post(
      Uri.parse(Urls.ChangeGuestToMember(guestId)),
      headers: {"Content-Type": "application/json",
        "Authorization":'Bearer ${token[1]}'},
    ).then((response) async {
      if (response.statusCode == 200) {
        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException();
      }
    });
    }



  }


