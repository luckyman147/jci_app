import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/config/services/TeamStore.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/Teams/data/models/TeamModel.dart';
import 'package:jci_app/features/Teams/domain/entities/Team/Team.dart';


import '../../../../../core/error/Exception.dart';
import '../../domain/repository/TeamRepo.dart';
import '../datasources/TeamLocalDataSources.dart';
import '../datasources/TeamRemoteDatasources.dart';

typedef TeamAction = Future<Unit> Function();
class TeamRepoImpl implements TeamRepo{
  final TeamRemoteDataSource teamRemoteDataSource;
  final TeamLocalDataSource teamLocalDataSource;
  final NetworkInfo networkInfo;
final Handler<Unit> unithandle;
final Handler<Team> Teamhandle;
final Handler<List<Team>> Teamshandle;
final Handler<({List<Team> Teams, DocumentSnapshot? lastDoc})> paginatedHandler;
  TeamRepoImpl(this.unithandle, this.Teamhandle, this.Teamshandle, this.paginatedHandler, {required this.teamRemoteDataSource, required this.teamLocalDataSource, required this.networkInfo});




  @override
  Future<Either<Failure, Team>> addTeam(Team team) async{

final teamMosdel=TeamModel.fromEntity(team,true);
    return
    await  Teamhandle.handle( onError: (e){
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      },onCall: () async=>
    await  teamRemoteDataSource.createTeam(teamMosdel));
  }

  @override
  Future<Either<Failure, Unit>> deleteTeam(String id) async{
    return
   await   unithandle.handle(onError: (e) {
        if (e is Exception) {
          return e.get_failure;
        } else {
          throw e;
        }
      }, onCall: ()async => await teamRemoteDataSource.deleteTeam(id));
  }

  @override
  Future<Either<Failure, Team>> getTeamById(String id,bool updated)async  {
 return
await Teamhandle.handle(onCall: ()async{
  if (updated) {
    final remoteTeams = await teamRemoteDataSource.getTeamById(id);
    teamLocalDataSource.cacheTeamByid(remoteTeams);
    return remoteTeams;}
  else{
try {
  final localTeams = await teamLocalDataSource.getTeamById(id);
  return localTeams;
}
on EmptyCacheException {
  throw EmptyCacheFailure();
}

  }
}, onError: (e){
  if (e is Exception) {
    return e.get_failure;
  } else {
    throw e;
  }
});





  }

  @override
  Future<Either<Failure, ({List<Team> Teams, DocumentSnapshot? lastDoc})>> getTeams(int limit,bool isPrivate,DocumentSnapshot? doc) async {
final CacheStatus status=isPrivate?CacheStatus.Private:CacheStatus.Public;
return await paginatedHandler.handle(onCall: ()async {
  final remoteTeams = await teamRemoteDataSource.getAllTeams(limit: limit, isPrivate: isPrivate,lastDocument:doc );
  teamLocalDataSource.cacheTeams(remoteTeams.Teams,status);
  return remoteTeams;

},onError: (e)async{
  if (e is Exception) {
    final localTeams= await teamLocalDataSource.getAllCachedTeams( status);
    if (localTeams==null) {
      throw EmptyCacheFailure();
    }
    return (Teams: localTeams, lastDoc: null);


  } else {
    throw e;
  }
});
  }

  @override
  Future<Either<Failure, Unit>> updateImage(String id, String path) {
    // TODO: implement updateImage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> updateTeam(Team team)async {
     final teamMosdel=TeamModel.fromEntity(team,false);

      return   await   unithandle.handle(onError: (e) {
       if (e is Exception) {
         return e.get_failure;
       } else {
         throw e;
       }
     }, onCall: ()async => await teamRemoteDataSource.updateTeam(teamMosdel));;
  }

  @override
  Future<Either<Failure, Unit>> uploadTeamImage(String id, String path) {
    // TODO: implement uploadTeamImage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Team>>> getTeamByName(String names)async  {
  return   await   Teamshandle.handle(onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    }, onCall: ()async =>await  teamRemoteDataSource.getTeamByName(names));


  }

  @override
  Future<Either<Failure, Unit>> UpdateMembers(String teamid, String memberid, String Status)async {
return
  await   unithandle.handle(onError: (e) {
  if (e is Exception) {
    return e.get_failure;
  } else {
    throw e;
  }
}, onCall: ()async => await teamRemoteDataSource.updateMembers(teamid, memberid, Status));

  }

  @override
  Future<Either<Failure, Unit>> InviteMember(String id, String memberid) async{
    return
      await   unithandle.handle(onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    }, onCall: ()async => await teamRemoteDataSource.inviteMember(id, memberid));

  }

  @override
  Future<Either<Failure, Unit>> JoinTeam(String id) async{
    return
      await   unithandle.handle(onError: (e) {
      if (e is Exception) {
        return e.get_failure;
      } else {
        throw e;
      }
    }, onCall: ()async => await teamRemoteDataSource.joinTeam(id));

  }


}