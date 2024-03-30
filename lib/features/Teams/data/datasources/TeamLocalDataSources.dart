import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/TeamStore.dart';
import 'package:jci_app/core/error/Exception.dart';



import '../models/TeamModel.dart';


abstract class TeamLocalDataSource {
  Future<List<TeamModel>> getAllCachedTeams(CacheStatus cacheStatus);



  Future<Unit> cacheTeams(List<TeamModel> Team,CacheStatus cacheStatus);
Future<Unit> cacheTeamByid(TeamModel Team);
Future<TeamModel> getTeamById(String id);


}

class TeamLocalDataSourceImpl implements TeamLocalDataSource{
  @override
  Future<Unit> cacheTeams(List<TeamModel> Team,CacheStatus cache)async {
    await TeamStore.cacheTeams(Team,cache);
    return Future.value(unit);
  }



  @override
  Future<List<TeamModel>> getAllCachedTeams(CacheStatus cache) async {
    final Teams=await TeamStore.getCachedTeams(cache);
    if (Teams.isNotEmpty) {
      return Teams;
    } else {
      throw EmptyCacheException();
    }
  }

  @override
  Future<Unit> cacheTeamByid(TeamModel Team) async {
    await TeamStore.cacheTeamByid(Team);
    return Future.value(unit);

  }

  @override
  Future<TeamModel> getTeamById(String id)async  {
    final Teams=await TeamStore.getTeamByid(id);
    if (Teams!=null) {
      return Teams;
    } else {
      throw EmptyCacheException();
    }
  }




}