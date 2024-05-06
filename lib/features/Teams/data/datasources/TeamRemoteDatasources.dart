
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import 'package:jci_app/core/config/env/urls.dart';



import 'package:http/http.dart' as http;
import 'package:jci_app/features/Teams/data/models/TeamModel.dart';


import '../../../../../core/config/services/store.dart';
import '../../../../../core/config/services/uploadImage.dart';
import '../../../../../core/config/services/verification.dart';
import '../../../../../core/error/Exception.dart';


abstract class TeamRemoteDataSource {
  Future<List<TeamModel>> getAllTeams(String page,String limit,bool isPrivate);
  Future<TeamModel> getTeamById(String id);

  Future<TeamModel> createTeam(TeamModel Team);
  Future<Unit> updateTeam(TeamModel Team);
  Future<Unit> deleteTeam(String id);
Future<List<TeamModel>> getTeamByName(String name);
Future<Unit> updateMembers(String teamid, String memberid, String Status);

  Future<Unit> inviteMember(String id, String memberid) ;

}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource{
  final http.Client client;

  TeamRemoteDataSourceImpl({required this.client});
  @override
  Future<TeamModel> createTeam(TeamModel Team)async  {
final tokens= await Store.GetTokens();
  final body =Team.toJson();
  debugPrint(body.toString()  );

  return client.post(
    Uri.parse(TeamUrl),
    headers: {"Content-Type": "application/json",
      "Authorization": "Bearer ${tokens[1]}"

    },
    body: json.encode(body),
  ).then((response) async {
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;


      final upload_response=await uploadImages(decodedJson['id'], Team.CoverImage,TeamUrl,"CoverImage");
    if (upload_response.statusCode==200){
      final bodyStream = upload_response.stream;
      final bodyBytes = await bodyStream.toBytes();
      final bodyString = utf8.decode(bodyBytes);
      return  TeamModel.fromJson(jsonDecode(bodyString));
      }
      else if (upload_response.statusCode==400){
        debugPrint(upload_response.reasonPhrase.toString());
        deleteTeam(decodedJson["_id"]);
        throw EmptyDataException();

      }else {
        throw ServerException();
      }

    }
    else if (response.statusCode == 400) {
      throw WrongCredentialsException();
    }
    else if  (response.statusCode == 401){
      throw UnauthorizedException();
    }

    else {
      throw ServerException();
    }
  });
  }

  @override
  Future<Unit> deleteTeam(String id)async {
    final response = await client.delete(

      Uri.parse(TeamUrl+"$id"),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode==204){
      return Future.value(unit);
    }
    else{
      throw ServerException();
    }
  }

  @override
  Future<List<TeamModel>> getAllTeams(String page,String limit,bool isPrivate)async  {
 final tokens=await Store.GetTokens();
    final response = await client.get(

      Uri.parse("${TeamUrl}All?start=$page&limit=$limit&isPrivate=$isPrivate"),
      headers: {"Content-Type": "application/json",

        "Authorization": "Bearer ${tokens[1]}"
      },


    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;
      if (decodedJson.containsKey('results')) {
      final List<TeamModel> TeamModels = (decodedJson['results'] as List)
          .map<TeamModel>((jsonEventModel) =>
          TeamModel.fromJson(jsonEventModel))
          .toList();
      return TeamModels;}
      else{
        throw EmptyDataException();
      }
    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<TeamModel> getTeamById(String id)async {


    final response =  await client.get(
      Uri.parse( TeamUrl+ 'get/$id'),

      headers: {"Content-Type": "application/json"},

    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;

      final TeamModel teamModel = TeamModel.fromJson(decodedJson);

      return teamModel;

    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }



  @override
  Future<Unit> updateTeam(TeamModel Team) {

    final body =Team.toUpdatejson();

    debugPrint(body.toString());
    return client.put(
      Uri.parse(TeamUrl+Team.id),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    ).then((response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;


        final update_response=await UpdateImage(decodedJson['_id'], Team.CoverImage,TeamUrl);
        if (update_response.statusCode==200){

          return Future.value(unit);
        }
        else if (update_response.statusCode==400){

          throw EmptyDataException();

        }else {
          throw ServerException();
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
  Future<List<TeamModel>> getTeamByName(String name) async{
    final tokens=await Store.GetTokens();
    final response =  client.get(
      Uri.parse( TeamUrl+ 'get?name=$name'),

      headers: {"Content-Type": "application/json",
      "Authorization": "Bearer ${tokens[1]}"


      },


    );

    return response.then((response) async {
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body) ;



        final List<TeamModel> teams = decodedJson.map((e) => TeamModel.fromJson(e)).toList();

        return teams;
      } else if (response.statusCode == 400) {
        throw EmptyDataException();
      }else{
        throw ServerException();
      }
    });
  }

  @override
  Future<Unit> updateMembers(String teamid, String memberid, String Status) async {
    final tokens=await Store.GetTokens();
    final response =  client.put(
      Uri.parse( Urls.TeamMember(teamid)),
body: json.encode({"Member":memberid,"Status":Status}),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${tokens[1]}"
      },


    );

    return response.then((response) async {
      log( response.statusCode.toString());
      if (response.statusCode == 200) {

        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw EmptyDataException();
      }else{
        throw ServerException();
      }
    });
  }

  @override
  Future<Unit> inviteMember(String id, String memberid) async{
     final tokens=await Store.GetTokens();
      return client.post(
        Uri.parse( Urls.InviteMemberUrl(id, memberid)),
        headers: {"Content-Type": "application/json",
          "Authorization": "Bearer ${tokens[1]}"
        },


      ).then((response) async {
        if (response.statusCode == 201) {
          return Future.value(unit);
        } else if (response.statusCode == 400) {
          throw EmptyDataException();
        }else{
          throw ServerException();
        }
      });
     }
  }

