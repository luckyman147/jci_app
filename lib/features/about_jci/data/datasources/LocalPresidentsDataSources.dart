import 'package:dartz/dartz.dart';

import '../../../../core/config/services/PresidentsStore.dart';
import '../models/PresidentModel.dart';

abstract class LocalPresidentsDataSources {
  Future<List<PresidentModel>> getPresidents();
  Future<Unit> CachePresidents(List<PresidentModel> presidents);

}
class LocalPresidentsDataSourcesImpl implements LocalPresidentsDataSources {
  @override
  Future<List<PresidentModel>> getPresidents()async  {
    return await PresidentStore.getCachedPresidents();

  }

  @override
  Future<Unit> CachePresidents(List<PresidentModel> presidents) async{
await PresidentStore.cachePresidents(presidents);
    return Future.value(unit);
  }
  }