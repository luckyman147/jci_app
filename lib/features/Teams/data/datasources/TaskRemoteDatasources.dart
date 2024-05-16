import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

import 'package:jci_app/core/config/env/urls.dart';



import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/services/uploadImage.dart';


import 'package:jci_app/features/Teams/data/models/CheckListModel.dart';
import 'package:jci_app/features/Teams/data/models/FileModel.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';

import '../../../../../core/error/Exception.dart';
import '../models/TaskModel.dart';


abstract class TaskRemoteDataSource {
  
  Future<List<TaskModel>> getTasksOfTeam(String id);
  Future<TaskModel> getTasksById(String id,String taskid);
  Future<Unit> DeleteFiles(String taskId, String file);
 Future<Unit> UpdateChecklistName(String taskId,String checkListId,String name);
  Future<TaskModel> AddTask(String id,String name);
Future<CheckListModel> addCheckList(String taskId,String name);


  Future<Unit> updateCheckList(String id,String taskId,String checkListId,CheckListModel checkList);
Future <Unit> updateIscompleted(String taskId,bool isCompleted);
Future <Unit> updateChecklistStatus(String taskId,String checkid,bool isCompleted);
Future <Unit> updateTaskName(String taskId,String name);
Future <Unit> UpdateMembers(String taskId,bool name,String MemberId);
Future <Unit> UpdateTimeline(String taskId,DateTime startdate,DateTime enddate);



Future<Unit> deleteCheckList(String checkListId);
Future<Unit> deleteTask(String taskid);
Future<FileModel> UpdateFiles(String taskId, FileModel file );

  Future<Unit> AddComment(String taskid, String comment) ;

  Future<Unit> DeleteComment(String taskid, String commentId) ;

  Future<Unit> UpdateComment(String taskid, String commentId, String comment);

}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource{
  final http.Client client;

  TaskRemoteDataSourceImpl({required this.client});




  @override
  Future<TaskModel> AddTask(String id,String name ) async {
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
  Future<CheckListModel> addCheckList( String taskId, String name) async {



    return client.post(
      Uri.parse("$TeamUrl$taskId/Checklist"),
      headers: {"Content-Type": "application/json",


      },

      body: json.encode({"name":name}),
    ).then((response) async {
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 201) {
        final Map<String, dynamic> decodedJson = json.decode(response.body) ;
        final CheckListModel checkListModel = CheckListModel.fromJson(decodedJson);

        return checkListModel;

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
  Future<Unit> deleteCheckList( String checkListId)async {

    final response=await  client.delete(
      Uri.parse("$TeamUrl/checklist/$checkListId"),
      headers: {"Content-Type": "application/json",
  }
    );
    if (response.statusCode == 204) {
      return Future.value(unit);
    } else if (response.statusCode == 404) {
      throw WrongCredentialsException();
    }
    else {
      throw ServerException();
    }


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
  Future<Unit> deleteTask( String taskid)async  {

    final response= await client.delete(
      Uri.parse("$TeamUrl/tasks/$taskid"),
      headers: {"Content-Type": "application/json",

  },);
    if (response.statusCode == 204) {
      return Future.value(unit);
    } else if (response.statusCode == 404) {
      throw WrongCredentialsException();

    }
    else {
      throw ServerException();
    }}

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

  @override
  Future<Unit> updateIscompleted(String taskId, bool isCompleted)async  {
    final response = await client.put(

      Uri.parse("$TeamUrl/$taskId/UpdateStatus"),
      headers: {"Content-Type": "application/json"},
body: jsonEncode({"IsCompleted":"$isCompleted"})
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {

      return Future.value(unit);
    } else if (response.statusCode == 404) {
      throw WrongCredentialsException();
    }else{
      throw ServerException();
    }

  }

  @override
  Future<Unit> updateChecklistStatus(String taskId, String checkid, bool isCompleted)async  {
    log("taskid $taskId    checkid $checkid  iscompleted $isCompleted");
    final response = await client.put(

        Uri.parse("$TeamUrl$taskId/UpdateCheckStatus/$checkid"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"IsCompleted":"$isCompleted"})
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {

      return Future.value(unit);
    } else if (response.statusCode == 404) {
      throw WrongCredentialsException();
    }else{
      throw ServerException();
    }



}



  @override
  Future<Unit> UpdateMembers(String taskId, bool status, String MemberId)async  {
    final response = await client.put(

        Uri.parse("$TeamUrl$taskId/UpdateMembers"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"Member":"$MemberId","Status":"$status"})
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {


      return Future.value(unit);
    }
    else if (response.statusCode == 404) {
      throw EmptyDataException();}
    else if (response.statusCode == 400) {
      throw WrongCredentialsException();
    }else{
      throw ServerException();
    }
  }

  @override
  Future<Unit> UpdateTimeline(String taskId, DateTime startdate, DateTime enddate)async {
    final response = await client.put(

        Uri.parse("$TeamUrl$taskId/UpdateDeadline"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"StartDate":"$startdate","Deadline":"$enddate"})
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {

      return Future.value(unit);
    }
    else if (response.statusCode == 404) {
      throw EmptyDataException();}
    else if (response.statusCode == 400) {
      throw WrongCredentialsException();
    }else{
      throw ServerException();
    }



  }

  @override
  Future<Unit> updateTaskName(String taskId, String name) async {

    final response = await client.put(

        Uri.parse("$TeamUrl/tasks/$taskId/UpdateName"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name":"$name"})
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {

      return Future.value(unit);
    } else if (response.statusCode == 404) {
      throw WrongCredentialsException();
    }else{
      throw ServerException();
    }


  }

  @override
  Future<Unit> DeleteFiles(String taskId, String file)async  {
    final response= await client.delete(
      Uri.parse("$TeamUrl/tasks/$taskId/File/$file"),
      headers: {"Content-Type": "application/json",

      },);
    if (response.statusCode == 204) {
      return Future.value(unit);
    } else if (response.statusCode == 404) {
      throw WrongCredentialsException();

    }
    else {
      throw ServerException();
    }}



  @override
  Future<FileModel> UpdateFiles(String taskId, FileModel file) async {
    final updatedFile = await uploadFile(taskId, file.path, TeamUrl, "File");

    // Read the response body as a stream and decode it
    final responseBody = await updatedFile.stream.bytesToString();

    if (updatedFile.statusCode == 200) {
      final decodedJson = json.decode(responseBody);
      log(decodedJson.toString());
      final FileModel fileModel = FileModel.fromJson(decodedJson);
      return fileModel;
    }
    else if (updatedFile.statusCode == 404) {
      throw EmptyDataException();
    }
   else if  (updatedFile.statusCode == 400) {
      throw WrongCredentialsException();
    }

    else {
      // Handle other status codes if needed
      throw Exception('Failed to update file: ${updatedFile.reasonPhrase}');
    }
  }

  @override
  Future<Unit> UpdateChecklistName(String taskId, String checkListId, String name)async  {
    final response = await client.put(

        Uri.parse("$TeamUrl$taskId/UpdateCheckName/$checkListId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name":"$name"})
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {

      return Future.value(unit);
    }
    else if (response.statusCode == 404) {
      throw EmptyDataException();}
    else if (response.statusCode == 400) {
      throw WrongCredentialsException();
    }else{
      throw ServerException();
    }



  }

  @override
  Future<Unit> AddComment(String taskid, String comment) async {
final response = await client.post(
      Uri.parse(Urls.AddCommentUrl(taskid)),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"comment": "$comment"}),
    );
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else if (response.statusCode == 404) {
      throw EmptyDataException();
    }
    else if (response.statusCode == 400) {
      throw WrongCredentialsException();
    }

    else {
      throw ServerException();
    }


  }

  @override
  Future<Unit> DeleteComment(String taskid, String commentId) {
    // TODO: implement DeleteComment
    throw UnimplementedError();
  }

  @override
  Future<Unit> UpdateComment(String taskid, String commentId, String comment) {
    // TODO: implement UpdateComment
    throw UnimplementedError();
  }


}