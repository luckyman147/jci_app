import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/env/urls.dart';



import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/features/Home/data/model/NoteModel.dart';


import '../../../../../core/config/services/verification.dart';
import '../../../../../core/error/Exception.dart';
import '../../model/meetingModel/MeetingModel.dart';
import '../activities/ActivityRemote.dart';

abstract class MeetingRemoteDataSource {
  Future<List<MeetingModel>> getAllMeetings();
  Future<MeetingModel> getMeetingById(String id);
  Future<List<MeetingModel>> getMeetingsOfTheWeek();


  Future<Unit> createMeeting(MeetingModel Meeting);

  Future<Unit> updateMeeting(MeetingModel Meeting);
  Future<Unit> deleteMeeting(String id);

  Future<Unit> leaveMeeting(String id);
  Future<Unit> participateMeeting(String id);
Future<List<NoteModel>> getModelNotesOfActivity(String activityId,String start,String limit);
Future<Unit> DeleteNote(String activityId,String noteId);
Future<NoteModel> CreateNoteOfActivity(String activityId,NoteModel note);
Future<Unit> UpdateNoteOfActivity(NoteModel note);
Future<Uint8List> downloadExcel(String activityId);
}

class MeetingRemoteDataSourceImpl implements MeetingRemoteDataSource{
  final http.Client client;

  MeetingRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> createMeeting(MeetingModel Meeting)async {
    final token = await getTokens();
final body = Meeting.toJson();
    return client.post(
      Uri.parse(createMeetingUrl),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${token[1]}"
      },
      body: json.encode(body),
    ).then((response) async {
      if (response.statusCode == 200) {


          return Future.value(unit);



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
  Future<Unit> deleteMeeting(String id)async {
    final token = await getTokens();
    final response = await client.delete(

      Uri.parse("$getMeetingsUrl$id"),
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
  Future<List<MeetingModel>> getAllMeetings()async  {
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response = await client.post(

      Uri.parse(getMeetingsUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('meetings')) {
        final List<MeetingModel> MeetingModels = (decodedJson['meetings'] as List)
            .map<MeetingModel>((jsonPostModel) =>
            MeetingModel.fromJson(jsonPostModel))
            .toList();

        return MeetingModels;
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
  Future<MeetingModel> getMeetingById(String id)async {

    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response =  await client.post(
      Uri.parse('${getMeetingsUrl}get/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;

      final MeetingModel meetingModel = MeetingModel.fromJson(decodedJson);
      return meetingModel;

    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }


  @override
  Future<List<MeetingModel>> getMeetingsOfTheWeek()async  {
    final member = await MemberStore.getModel();
    final memberId = member!.id;
    final response = await client.post(
      Uri.parse(getMeetingByWeek),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),

    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('meetings')) {
        final List<MeetingModel> MeetingModels = (decodedJson['meetings'] as List)
            .map<MeetingModel>((jsonMeetingModel) =>
            MeetingModel.fromJson(jsonMeetingModel))
            .toList();

        return MeetingModels;
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
  Future<Unit> leaveMeeting(String id) async{
    return leaveActivity(id, client, getMeetingsUrl);

  }


  @override
  Future<Unit> participateMeeting(String id)async  {
    return await ParticiActivity(id, client, getMeetingsUrl);
  }

  @override
  Future<Unit> updateMeeting(MeetingModel Meeting)async  {
    final tokens= await getTokens();
    final body =Meeting.toJson();
    return client.patch(
      Uri.parse("$getMeetingsUrl${Meeting.id}/edit"),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${tokens[1]}"},
      body: json.encode(body),
    ).then((response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;
         return Future.value(unit);

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
  Future<NoteModel> CreateNoteOfActivity(String activityId, NoteModel note)async {
    final token = await getTokens();
    final body = note.toJson();
    return client.post(
      Uri.parse(Urls.AddNotes(activityId)),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${token[1]}"
      },
      body: json.encode(body),
    ).then((response) async {
      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;
        final NoteModel noteModel = NoteModel.fromJson(decodedJson);
        return noteModel;
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
  Future<Unit> DeleteNote(String id, String noteId)async {
final token = await getTokens();
    final response = await client.delete(
      Uri.parse(Urls.DeleteNotes(id,noteId)),
  headers: {"Content-Type": "application/json",
    "Authorization": "Bearer ${token[1]}"
  },
    );
    if (response.statusCode==200){
      return Future.value(unit);
    }
    else{
      throw EmptyDataException();
    }




  }

  @override
  Future<Unit> UpdateNoteOfActivity( NoteModel note) async{
final token = await getTokens();
    final body = note.toJson();
    return client.patch(
      Uri.parse(Urls.UpdateNotes(note.id)),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${token[1]}"},
      body: json.encode(body),
    ).then((response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;
        return Future.value(unit);

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
  Future<List<NoteModel>> getModelNotesOfActivity(String activityId,String start,String limit)async {
    final token = await getTokens();
    final response = await client.get(
      Uri.parse(Urls.GetNotes(activityId, start, limit)),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${token[1]}"
      },
    );
    if (response.statusCode == 200) {
      final List  decodedJson = json.decode(response.body);
      final List<NoteModel> noteModels = decodedJson.map<NoteModel>((jsonNoteModel) =>
          NoteModel.fromJson(jsonNoteModel))
          .toList();
      return noteModels;

    } else if (response.statusCode == 400) {
      throw EmptyDataException();


      // TODO: implement getModelNotesOfActivity

    }
    else{
      throw ServerException();
    }
  }

  @override
  Future<Uint8List> downloadExcel(String activityId)async {
    final response = await http.get(Uri.parse(Urls.downloadUrl(activityId)));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw WrongCredentialsException();
    }
  }

}