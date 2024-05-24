import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/network/network_info.dart';
import 'package:jci_app/features/about_jci/Domain/Repository/BoardRepo.dart';
import 'package:jci_app/features/about_jci/Domain/entities/BoardRole.dart';
import 'package:jci_app/features/about_jci/Domain/entities/BoardYear.dart';

import 'package:jci_app/features/about_jci/data/models/BoardRoleModel.dart';

import '../../../../core/error/Exception.dart';
import '../datasources/Board/LocalBoardDataSources.dart';
import '../datasources/Board/RemoteBoardDataSources.dart';

class BoardRepoImpl implements BoardRepo{

  final NetworkInfo networkInfo;
final RemoteBoardDataSources remoteBoardDataSources;
final LocalBoardDataSources localBoardDataSources;
  BoardRepoImpl({required this.networkInfo,required this.remoteBoardDataSources,required this.localBoardDataSources });
  @override
  Future<Either<Failure, List<String>>> getYears() async {
    if(await networkInfo.isConnected){
     final result= await remoteBoardDataSources.getYears();
      localBoardDataSources.CacheYears(result);
        return Right(result);

  }
    else{
      try{
        final result= await localBoardDataSources.getYears();
        return Right(result);
      }on Exception{
        return Left(EmptyCacheFailure());
      }

    }
  }

  @override
  Future<Either<Failure, Unit>> AddBoard(String year)async {
  return await _getMessage(remoteBoardDataSources.addBoard(year));
  }

  @override
  Future<Either<Failure, Unit>> AddBoardRole(BoardRole boardRole)async {
    await localBoardDataSources.CacheIsYUpdated(true,boardRole.priority);
    return await  _getMessage(remoteBoardDataSources.AddRole(BoardRoleModel.fromEntity(boardRole)));
  }

  @override
  Future<Either<Failure, BoardYear>> getBoardByYear(String year)async {
    if(await networkInfo.isConnected){
      final result= await remoteBoardDataSources.getBoardByYear(year);
      localBoardDataSources.CacheBoard(year,result);
      return Right(result);

    }
    else{
      try{
        final result= await localBoardDataSources.getBoard(year);
        if (result==null){
          return Left(EmptyCacheFailure());
        }
        return Right(result);
      }on Exception{
        return Left(EmptyCacheFailure());
      }

    }
  }

  @override
  Future<Either<Failure, List<BoardRole>>> getBoardRoles(int priority) async{
    if(await networkInfo.isConnected ){
      final isUpdated=await localBoardDataSources.getIsUpdated(priority);

      final resul= await localBoardDataSources.getBoardRoles(priority);
      if (isUpdated  || resul.isEmpty){
        final result= await remoteBoardDataSources.getBoardRoles(priority);
        localBoardDataSources.CacheBoardRoles(result,priority);
        localBoardDataSources.CacheIsYUpdated(false,priority);
        return Right(result);
      }
      return Right(resul);


    }
    else{
      try{
        final result= await localBoardDataSources.getBoardRoles(priority);
        return Right(result);
      }on Exception{
        return Left(EmptyCacheFailure());
      }

    }
  }
  Future<Either<Failure, Unit>> _getMessage(
      Future<Unit> board) async {
    if (await networkInfo.isConnected) {
      try {
        await board;
        return const Right(unit);
      }

      on EmptyDataException {
        return Left(EmptyDataFailure());
      } on WrongCredentialsException {
        return Left(WrongCredentialsFailure());
      }
      on UnauthorizedException {

        return Left(UnauthorizedFailure());
      }
      on ServerException {
        return Left(ServerFailure());
      }
    }


    else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> RemoveBoard(String year)async {

    return  await _getMessage(remoteBoardDataSources.RemoveBoard(year));

  }

  @override
  Future<Either<Failure, Unit>> AddPositionInBoard(String year,String role )async {
    return  await _getMessage(remoteBoardDataSources.AddPositionInBoard(year,role));
  }

  @override
  Future<Either<Failure, Unit>> AddMemberBoard(String id, String memberId) async {
    return  await _getMessage(remoteBoardDataSources.AddMemberBoard(id,memberId));

  }


  @override
  Future<Either<Failure, Unit>> RemoveMemberBoard(String id, String memberId) async{
    return  await _getMessage(remoteBoardDataSources.RemoveMemberBoard(id,memberId));

  }

  @override
  Future<Either<Failure, Unit>> RemovePositionInBoard(String postId, String year)async  {

    return await  _getMessage(remoteBoardDataSources.RemovePost(postId,year));
  }

  @override
  Future<Either<Failure, Unit>> RemoveBoardRole(String roleId) async{
    await localBoardDataSources.CacheIsYUpdated(true,1);
    await localBoardDataSources.CacheIsYUpdated(true,2);
    await localBoardDataSources.CacheIsYUpdated(true,3);

     return await  _getMessage(remoteBoardDataSources.RemoveRole(roleId));
  }
}