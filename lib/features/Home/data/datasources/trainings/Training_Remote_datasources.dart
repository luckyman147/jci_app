import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:jci_app/core/config/env/urls.dart';



import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/verification.dart';


import '../../../../../core/config/services/store.dart';
import '../../../../../core/config/services/uploadImage.dart';
import '../../../../../core/error/Exception.dart';

import '../../model/TrainingModel/TrainingModel.dart';

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

}

class TrainingRemoteDataSourceImpl implements TrainingRemoteDataSource{
  final http.Client client;

  TrainingRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> createTraining(TrainingModel Training) {
    debugPrint("coverimagze from  ");
    debugPrint(Training.CoverImages.first);
    final body =Training.toJson();
    return client.post(
      Uri.parse(createTrainingUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    ).then((response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;


        final upload_response=await uploadImages(decodedJson['_id'], Training.CoverImages.first,getTrainingsUrl,"CoverImages");
        if (upload_response.statusCode==200){
          return Future.value(unit);
        }
        else if (upload_response.statusCode==400){
          debugPrint(upload_response.reasonPhrase.toString());
          deleteTraining(decodedJson["_id"]);
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
  Future<Unit> deleteTraining(String id) async {
    final response = await client.delete(

      Uri.parse(getTrainingsUrl+"$id"),
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
  Future<List<TrainingModel>> getAllTraining()async  {
    final member = await Store.getModel();
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
    final member = await Store.getModel();
    final memberId = member!.id;
    final response =  await client.post(
      Uri.parse(getTrainingsUrl + 'get/$id'),
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
    final member = await Store.getModel();
    final memberId = member!.id;
    final response =  await client.post(
      Uri.parse(getTrainingByMonth),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),

    );
    print(response.statusCode);
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
    final member = await Store.getModel();
    final memberId = member!.id;
    final response = await client.post(

      Uri.parse(getTrainingByWeek),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"id": memberId}),
    );
    print(response.statusCode);
    print("object");
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
  Future<Unit> updateTraining(TrainingModel Training) {
    final body =Training.toJson();
    return client.patch(
      Uri.parse(getTrainingsUrl+Training.id+"/edit"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    ).then((response) async {
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;


        final Update_response=await UpdateImage(decodedJson['_id'], Training.CoverImages.first,getTrainingsUrl);
        if (Update_response.statusCode==200){
          return Future.value(unit);
        }
        else if (Update_response.statusCode==400){

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