import 'package:dartz/dartz.dart';

import '../../../../core/config/services/PresidentsStore.dart';
import '../models/PresidentModel.dart';

abstract class LocalPresidentsDataSources {
  Future<List<PresidentModel>> getPresidents(String start,String limit);
  Future<bool> getUpdated();
  Future<Unit> CachePresidents(List<PresidentModel> presidents, String start,String limit);
  Future<Unit> CacheUpdated(bool isUpdated);


}
class LocalPresidentsDataSourcesImpl implements LocalPresidentsDataSources {
  @override
  Future<List<PresidentModel>> getPresidents(String start,String limit)async  {
    return await PresidentStore.getCachedPresidents(start,limit);

  }

  @override
  Future<Unit> CachePresidents(List<PresidentModel> presidents,String start,String limit) async{
await PresidentStore.cachePresidents(presidents,start,limit);
    return Future.value(unit);
  }

  @override
  Future<Unit> CacheUpdated(bool isUpdated) async{
 await PresidentStore.setUpdated(isUpdated);
    return Future.value(unit);
  }

  @override
  Future<bool> getUpdated() async {
    return await PresidentStore.getUpdated();

  }
  }