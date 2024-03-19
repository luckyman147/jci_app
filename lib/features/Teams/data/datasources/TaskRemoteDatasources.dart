import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import 'package:jci_app/core/config/env/urls.dart';



import 'package:http/http.dart' as http;


import 'package:jci_app/features/Teams/data/models/CheckListModel.dart';


import '../../../../../core/config/services/store.dart';
import '../../../../../core/config/services/uploadImage.dart';
import '../../../../../core/config/services/verification.dart';
import '../../../../../core/error/Exception.dart';
import '../models/TaskModel.dart';


abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasksOfTeam(String id);
  Future<TaskModel> getTasksById(String id,String taskid);

  Future<TaskModel> AddTask(String id,String name);
  Future<Unit> updateTask(String id,TaskModel Task);
  Future<Unit> deleteTask(String id,String taskid);
  Future<List<CheckListModel>> getCheckList(String id,String taskId);
Future<Unit> addCheckList(String id,String taskId,List<CheckListModel> checkList);
Future<Unit> updateCheckList(String id,String taskId,String checkListId,CheckListModel checkList);
Future<Unit> deleteCheckList(String id,String taskId,String checkListId);
Future<Unit> addComment(String id,String taskId,String comment);

}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource{
  final http.Client client;

  TaskRemoteDataSourceImpl({required this.client});




  @override
  Future<TaskModel> AddTask(String id,String name ) async {



    debugPrint("name $name");
    return client.post(
      Uri.parse("$TeamUrl$id/tasks"),
      headers: {"Content-Type": "application/json",


      },

      body: json.encode({"name":name}),
    ).then((response) async {
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 201) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;
        final TaskModel taskModel = TaskModel.fromJson(decodedJson);

        return taskModel;

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
  Future<Unit> addCheckList(String id, String taskId, List<CheckListModel> checkList) {
    // TODO: implement addCheckList
    throw UnimplementedError();
  }

  @override
  Future<Unit> addComment(String id, String taskId, String comment) {
    // TODO: implement addComment
    throw UnimplementedError();
  }

  @override
  Future<Unit> deleteCheckList(String id, String taskId, String checkListId) {
    // TODO: implement deleteCheckList
    throw UnimplementedError();
  }

  @override
  Future<List<CheckListModel>> getCheckList(String id, String taskId) {
    // TODO: implement getCheckList
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> getTasksById(String id, String taskid)async  {


    final response =  await client.get(
      Uri.parse( '${TeamUrl}$id/tasks/$taskid'),

      headers: {"Content-Type": "application/json"},

    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body) ;

      final TaskModel taskModel = TaskModel.fromJson(decodedJson);
      return taskModel;

    } else if (response.statusCode == 400) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }


  @override
  Future<Unit> updateCheckList(String id, String taskId, String checkListId, CheckListModel checkList) {
    // TODO: implement updateCheckList
    throw UnimplementedError();
  }

  @override
  Future<Unit> deleteTask(String id, String taskid) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<Unit> updateTask( String id, TaskModel Task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getTasksOfTeam(String id)async {

    final response = await client.get(

      Uri.parse("$TeamUrl/$id/tasks"),
      headers: {"Content-Type": "application/json"},

    );
log(response.statusCode.toString());
log(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> decodedJson = json.decode(response.body) ;


      log("message");
      final List<TaskModel> tasks = decodedJson.map((e) => TaskModel.fromJson(e)).toList();

      return tasks;
    } else if (response.statusCode == 404) {
      throw EmptyDataException();
    }else{
      throw ServerException();
    }
  }


}