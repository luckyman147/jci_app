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
  Future<List<TeamModel>> getAllTeams();
  Future<TeamModel> getTeamById(String id);

  Future<Unit> createTeam(TeamModel Team);
  Future<Unit> updateTeam(TeamModel Team);
  Future<Unit> deleteTeam(String id);


}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource{
  final http.Client client;

  TeamRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> createTeam(TeamModel Team)async  {
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


      final upload_response=await uploadImages(decodedJson['_id'], Team.CoverImage,TeamUrl,"CoverImage");
    if (upload_response.statusCode==200){
      log("message");
        return Future.value(unit);
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
      throw EmptyDataException();
    }
  }

  @override
  Future<List<TeamModel>> getAllTeams()async  {
    final member = await Store.getModel();
    final memberId = member!.id;
    final response = await client.get(

      Uri.parse(TeamUrl+"All"),
      headers: {"Content-Type": "application/json"},

    );

    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = json.decode(response.body) ;

      final List<TeamModel> teamModel = decodedJson.map((e) => TeamModel.fromJson(e)).toList();
      return teamModel;
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
    final body =Team.toJson();
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

}