import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/TeamStore.dart';


import '../../../../core/error/Exception.dart';
import '../models/TaskModel.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllCachedTasks();



  Future<Unit> cacheTasks(List<TaskModel> tasks);



}

class TaskLocalDataSourceImpl implements TaskLocalDataSource{
  @override
  Future<Unit> cacheTasks(List<TaskModel> Task)async {
    await TeamStore.cacheTasks(Task);
    return Future.value(unit);
  }



  @override
  Future<List<TaskModel>> getAllCachedTasks() async {
    final Tasks=await TeamStore.getCachedTasks();
    if (Tasks.isNotEmpty) {
      return Tasks;
    } else {
      throw EmptyCacheException();
    }
  }




}