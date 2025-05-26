import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/TrainingStore.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/model/GuestModel.dart';
import 'package:jci_app/features/Home/data/model/TrainingModel/TrainingModel.dart';

import '../../../../../../core/config/services/verification.dart';

abstract class TrainingLocalDataSource {
  Future<List<TrainingModel>> getAllCachedTrainings();
  Future<TrainingModel?> getCachedTrainingById(String id);
  Future<List<TrainingModel>> getCachedTrainingsOfTheWeek();
  Future<List<TrainingModel>> getCachedTrainingsOfTheMonth();

  Future<Unit> cacheTrainings(List<TrainingModel> Training);
  Future<Unit> cacheTrainingById(TrainingModel Training);
  Future<Unit> cacheGuests(List<GuestModel> guests);
  Future<List<GuestModel>> getAllCachedGuests();
  Future<Unit> cacheTrainingsOfTheWeek(List<TrainingModel> Training);
  Future<Unit> cacheTrainingsOfTheMonth(List<TrainingModel> Training);

  Future<bool> checkPermissions();

  Future<void> deleteTraining(String id);

  Future<void> cacheTraining(TrainingModel result);
}

class TrainingLocalDataSourceImpl implements TrainingLocalDataSource {
  final Store store;

  TrainingLocalDataSourceImpl({required this.store});
  @override
  Future<Unit> cacheTrainings(List<TrainingModel> Training) async {
    await TrainingStore.cacheTrainings(Training);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheTrainingsOfTheMonth(List<TrainingModel> Training) async {
    await TrainingStore.cacheTrainingsOfThemonth(Training);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheTrainingsOfTheWeek(List<TrainingModel> Training) async {
    throw UnimplementedError();
  }

  @override
  Future<List<TrainingModel>> getAllCachedTrainings() async {
    final Trainings = await TrainingStore.getCachedTrainings();
    if (Trainings.isNotEmpty) {
      return Trainings.toSet().toList();
    } else {
      return [];
    }
  }

  @override
  Future<TrainingModel?> getCachedTrainingById(String id) async {
    final Training = await TrainingStore.getCachedTrainingById(id);
    if (Training != null) {
      return Training;
    } else {
      return null;
    }
  }

  @override
  Future<List<TrainingModel>> getCachedTrainingsOfTheMonth() async {
    final Trainings = await TrainingStore.getCachedTrainingsOfTheMonth();
    if (Trainings.isNotEmpty) {
      return Trainings.toSet().toList();
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<List<TrainingModel>> getCachedTrainingsOfTheWeek() async {
    throw UnimplementedError();
  }

  @override
  Future<Unit> cacheGuests(List<GuestModel> guests) async {
    await TrainingStore.cacheGuests(guests);
    return Future.value(unit);
  }

  @override
  Future<List<GuestModel>> getAllCachedGuests() async {
    final guests = await TrainingStore.getGuests();
    if (guests.isNotEmpty) {
      return guests;
    } else {
      return [];
    }
  }

  @override
  Future<bool> checkPermissions() async {
    final eventPermission = await TrainingStore.getTrainPer();
    final userPermissions = store.getPermissions();
    if (eventPermission.isEmpty || userPermissions!.isEmpty) {
      return false;
    } else {
      return hasCommonElement(eventPermission, userPermissions) ? true : false;
    }
  }

  @override
  Future<void> deleteTraining(String id) async {
    await TrainingStore.deleteTraining(id);
  }

  @override
  Future<void> cacheTraining(TrainingModel result) async {
    try {
      await TrainingStore.cacheTraining(result);
    } catch (e) {
      throw WrongVerificationException();
    }
  }

  @override
  Future<Unit> cacheTrainingById(TrainingModel Training) async {
    await TrainingStore.cacheTrainingBYId(Training);
    return Future.value(unit);
  }
}
