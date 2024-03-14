import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/TeamStore.dart';
import 'package:jci_app/core/error/Exception.dart';



import '../models/TeamModel.dart';


abstract class TeamLocalDataSource {
  Future<List<TeamModel>> getAllCachedTeams();



  Future<Unit> cacheTeams(List<TeamModel> Team);



}

class TeamLocalDataSourceImpl implements TeamLocalDataSource{
  @override
  Future<Unit> cacheTeams(List<TeamModel> Team)async {
    await TeamStore.cacheTeams(Team);
    return Future.value(unit);
  }



  @override
  Future<List<TeamModel>> getAllCachedTeams() async {
    final Teams=await TeamStore.getCachedTeams();
    if (Teams.isNotEmpty) {
      return Teams;
    } else {
      throw EmptyCacheException();
    }
  }




}