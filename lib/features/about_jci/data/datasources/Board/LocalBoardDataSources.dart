import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/BoardStore.dart';
import 'package:jci_app/features/about_jci/data/models/BoardYearModel.dart';

import '../../models/BoardRoleModel.dart';

abstract class LocalBoardDataSources{
  Future<List<String>> getYears();
  Future<Unit> CacheYears(List<String> years);
  Future<Unit> CacheBoard(String year,BoardYearModel board);
  Future<BoardYearModel?> getBoard(String year);
  Future<List<BoardRoleModel>> getBoardRoles(int priority);
  Future<Unit> CacheBoardRoles(List<BoardRoleModel> liste,int priority);


}
class LocalBoardDataSourcesImpl implements LocalBoardDataSources {
  @override
  Future<List<String>> getYears() async {
  return BoardStore.getCachedYears();
  }

  @override
  Future<Unit> CacheYears(List<String> years) async {
     await BoardStore.cacheYears(years);
     return Future.value(unit);
  }

  @override
  Future<Unit> CacheBoard(String year, BoardYearModel board) async{
    await BoardStore.cacheBoard(year, board);
    return Future.value(unit);

  }

  @override
  Future<BoardYearModel?> getBoard(String year) {

    return BoardStore.getBoards(year);
  }

  @override
  Future<Unit> CacheBoardRoles(List<BoardRoleModel> liste, int priority)async {
    await BoardStore.cacheBoardRoles(priority, liste);
    return Future.value(unit);
  }

  @override
  Future<List<BoardRoleModel>> getBoardRoles(int priority) {
    return BoardStore.getBoardRoles(priority);
  }


}