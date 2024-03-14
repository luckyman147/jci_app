import 'dart:convert';
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
  Future<List<TaskModel>> getTasksOfTask(String id);
  Future<TaskModel> getTasksById(String id,String taskid);

  Future<Unit> AddTask(String id,TaskModel Task);
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
  Future<Unit> AddTask(String id, TaskModel Task) {
    // TODO: implement AddTask
    throw UnimplementedError();
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
  Future<TaskModel> getTasksById(String id, String taskid) {
    // TODO: implement getTasksById
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getTasksOfTask(String id) {
    // TODO: implement getTasksOfTask
    throw UnimplementedError();
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

}