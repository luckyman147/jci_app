import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/TrainingStore.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/model/GuestModel.dart';



import '../../model/TrainingModel/TrainingModel.dart';


abstract class TrainingLocalDataSource {
  Future<List<TrainingModel>> getAllCachedTrainings();
  Future<TrainingModel> getCachedTrainingById(String id);
  Future<List<TrainingModel>> getCachedTrainingsOfTheWeek();
  Future<List<TrainingModel>> getCachedTrainingsOfTheMonth();

  Future<Unit> cacheTrainings(List<TrainingModel> Training);
  Future<Unit> cacheGuests(List<GuestModel> guests);
  Future<List<GuestModel>> getAllCachedGuests();
  Future<Unit> cacheTrainingsOfTheWeek(List<TrainingModel> Training);
  Future<Unit> cacheTrainingsOfTheMonth(List<TrainingModel> Training);


}

class TrainingLocalDataSourceImpl implements TrainingLocalDataSource{
  @override
  Future<Unit> cacheTrainings(List<TrainingModel> Training)async {
    await TrainingStore.cacheTrainings(Training);
    return Future.value(unit);
  }

  @override
  Future<Unit> cacheTrainingsOfTheMonth(List<TrainingModel> Training) async {
    throw UnimplementedError();

  }

  @override
  Future<Unit> cacheTrainingsOfTheWeek(List<TrainingModel> Training) async {
    throw UnimplementedError();

  }

  @override
  Future<List<TrainingModel>> getAllCachedTrainings() async {
    final Trainings=await TrainingStore.getCachedTrainings();
    if (Trainings.isNotEmpty) {
      return Trainings;
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<TrainingModel> getCachedTrainingById(String id) {
    // TODO: implement getCachedTrainingById
    throw UnimplementedError();
  }

  @override
  Future<List<TrainingModel>> getCachedTrainingsOfTheMonth() async{
    throw UnimplementedError();

  }

  @override
  Future<List<TrainingModel>> getCachedTrainingsOfTheWeek()async {
    throw UnimplementedError();


  }

  @override
  Future<Unit> cacheGuests(List<GuestModel> guests) async {
    await TrainingStore.cacheGuests(guests);
    return Future.value(unit);

  }

  @override
  Future<List<GuestModel>> getAllCachedGuests()async  {
    final guests=await TrainingStore.getGuests();
    if (guests.isNotEmpty) {
      return guests;
    } else {
      throw EmptyCacheException();
    }

  }
}