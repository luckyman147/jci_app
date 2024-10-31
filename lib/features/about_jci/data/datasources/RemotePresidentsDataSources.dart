import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:jci_app/core/config/services/verification.dart';
import 'package:jci_app/features/about_jci/data/models/PresidentModel.dart';

import 'package:http/http.dart' as http;
import '../../../../core/config/env/urls.dart';
import '../../../../core/config/services/uploadImage.dart';
import '../../../../core/error/Exception.dart';

abstract class RemotePresidentsDataSources {
  Future<List<PresidentModel>> getPresidents(String start,String limit);
  Future<PresidentModel> CreatePresident(PresidentModel president);
  Future<Unit> DeletePresident(String id);
  Future<PresidentModel> UpdatePresident(PresidentModel president);
  Future<PresidentModel> UpdateImagePresident(PresidentModel president);
}
class RemotePresidentsDataSourcesImpl implements RemotePresidentsDataSources {
  final http.Client client;

  RemotePresidentsDataSourcesImpl({required this.client});
  @override
  Future<PresidentModel> CreatePresident(PresidentModel president) async{
    final tokens = await getTokens();
    final body =president.toJson();
    debugPrint(body.toString()  );

    return client.post(
      Uri.parse(CreatePresidents()),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${tokens[1]}"

      },
      body: json.encode(body),
    ).then((response) async {
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 201) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;
        final presidents = PresidentModel.fromJson(decodedJson);


        return presidents;

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

  Future<PresidentModel> uploadimagefunct(Map<String, dynamic> decodedJson, PresidentModel president, PresidentModel presidents) async {
         final uploadResponse=await uploadImages(decodedJson['_id'], president.CoverImage,'$SuperAdminUrl/',"CoverImage");

    if (uploadResponse.statusCode==201){
     return presidents;
    }
    else if (uploadResponse.statusCode==400){
      debugPrint(uploadResponse.reasonPhrase.toString());
      DeletePresident(decodedJson["_id"]);
      throw EmptyDataException();

    }else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> DeletePresident(String id)async {
    final tokens = await getTokens();
    return client.delete(
      Uri.parse(DeletePresidents(id)),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${tokens[1]}"
      },
    ).then((response) async {
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 204) {
        return Future.value(unit);
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
  Future<PresidentModel> UpdateImagePresident(PresidentModel presidentModel)async {
    final uploadResponse=await uploadImages(presidentModel.id, presidentModel.CoverImage,"$SuperAdminUrl/","CoverImage");
    if (uploadResponse.statusCode==201){
      final decodedJson = json.decode(await uploadResponse.stream.bytesToString());
      return //display the image// ;
PresidentModel.fromJson(decodedJson);
    }
    else if (uploadResponse.statusCode==400){

      throw EmptyDataException();

    }else {
      throw ServerException();
    }
  }

  @override
  Future<PresidentModel> UpdatePresident(PresidentModel president)async {
    final tokens = await getTokens();
    final body =president.toJson();
    return client.patch(
      Uri.parse(UpdatePresidents(president.id)),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${tokens[1]}"
      },

      body: json.encode(body),
    ).then((response) async {
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 201) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;
        final president = PresidentModel.fromJson(decodedJson);
        return president;
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
  Future<List<PresidentModel>> getPresidents(String start,String limit) {
    return client.get(Uri.parse(getAllPresidents(start,limit))).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body);
        return decodedJson.map((json) => PresidentModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    });
  }
}
