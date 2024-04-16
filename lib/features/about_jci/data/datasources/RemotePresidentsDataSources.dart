import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/core/config/services/verification.dart';
import 'package:jci_app/features/about_jci/data/models/PresidentModel.dart';

import 'package:http/http.dart' as http;
import '../../../../core/config/env/urls.dart';
import '../../../../core/config/services/uploadImage.dart';
import '../../../../core/error/Exception.dart';

abstract class RemotePresidentsDataSources {
  Future<List<PresidentModel>> getPresidents();
  Future<Unit> CreatePresident(PresidentModel president);
  Future<Unit> DeletePresident(String id);
  Future<Unit> UpdatePresident(PresidentModel president);
  Future<Unit> UpdateImagePresident(PresidentModel president);
}
class RemotePresidentsDataSourcesImpl implements RemotePresidentsDataSources {
  final http.Client client;

  RemotePresidentsDataSourcesImpl({required this.client});
  @override
  Future<Unit> CreatePresident(PresidentModel president) async{
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


        final upload_response=await uploadImages(decodedJson['_id'], president.CoverImage,SuperAdminUrl,"CoverImage");
        if (upload_response.statusCode==201){
         return Future.value(unit);
        }
        else if (upload_response.statusCode==400){
          debugPrint(upload_response.reasonPhrase.toString());
          DeletePresident(decodedJson["_id"]);
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
  Future<Unit> UpdateImagePresident(PresidentModel presidentModel)async {
    final upload_response=await uploadImages(presidentModel.id, presidentModel.CoverImage,SuperAdminUrl,"CoverImage");
    if (upload_response.statusCode==201){
      return Future.value(unit);
    }
    else if (upload_response.statusCode==400){

      throw EmptyDataException();

    }else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> UpdatePresident(PresidentModel president)async {
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
  Future<List<PresidentModel>> getPresidents() {
    return client.get(Uri.parse(getAllPresidents())).then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body);
        return decodedJson.map((json) => PresidentModel.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    });
  }
}
