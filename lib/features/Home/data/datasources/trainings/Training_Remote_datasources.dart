import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/env/urls.dart';



import 'package:http/http.dart' as http;


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

  Future<bool> leaveTraining(String id);
  Future<bool> participateTraining(String id);

}

class TrainingRemoteDataSourceImpl implements TrainingRemoteDataSource{
  final http.Client client;

  TrainingRemoteDataSourceImpl({required this.client});
  @override
  Future<Unit> createTraining(TrainingModel Training) {
    // TODO: implement createTraining
    throw UnimplementedError();
  }

  @override
  Future<Unit> deleteTraining(String id) {
    // TODO: implement deleteTraining
    throw UnimplementedError();
  }

  @override
  Future<List<TrainingModel>> getAllTraining()async  {
    final response = await client.get(

      Uri.parse(getTrainingsUrl),
      headers: {"Content-Type": "application/json"},
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
    final response =  await client.get(
      Uri.parse(getTrainingsUrl + '$id'),
      headers: {"Content-Type": "application/json"},
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
    final response =  await client.get(
      Uri.parse(getTrainingByMonth),
      headers: {"Content-Type": "application/json"},
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
    final response = await client.get(
      Uri.parse(getTrainingByWeek),
      headers: {"Content-Type": "application/json"},
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
  Future<bool> leaveTraining(String id) {
    // TODO: implement leaveTraining
    throw UnimplementedError();
  }

  @override
  Future<bool> participateTraining(String id) {
    // TODO: implement participateTraining
    throw UnimplementedError();
  }

  @override
  Future<Unit> updateTraining(TrainingModel Training) {
    // TODO: implement updateTraining
    throw UnimplementedError();
  }
}