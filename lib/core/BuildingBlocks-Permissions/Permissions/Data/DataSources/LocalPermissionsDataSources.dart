import 'package:dartz/dartz.dart';

import '../../../../config/services/permissionService/PermissionsStore.dart';
import '../../domain/Dtos/CheckPermissionDtos.dart';
import '../../domain/Dtos/LoadPermission.dart';
import '../Models/FeaturePermissionsModel.dart';

abstract class LocalDataSources{
  Future<FeaturePermissionsModel> loadLocalPermissionsOfUser(LoadPermissionsOfUser loadPermissionsOfUser);
  Future<List<FeaturePermissionsModel>>loadLocalPermissionsOfMaster(
      List<String> featureIds);
  Future<bool?> checkLocaledPermission(CheckPermissionDtos checkPermissionDtos);
Future<Unit> SaveFeaturesOfMaster(List<FeaturePermissionsModel> models,);


}
class LocalPermissionsDataSources implements LocalDataSources{
  final SecurePermissionStore securePermissionStore;

  LocalPermissionsDataSources({required this.securePermissionStore});
  @override
  Future<bool?> checkLocaledPermission(CheckPermissionDtos checkPermissionDtos) {
    // TODO: implement checkLocaledPermission
    throw UnimplementedError();
  }

  @override
  Future<List<FeaturePermissionsModel>> loadLocalPermissionsOfMaster(List<String> featureIds) async{
    return await securePermissionStore.getPermissions(featureIds);

  }

  @override
  Future<FeaturePermissionsModel> loadLocalPermissionsOfUser(LoadPermissionsOfUser loadPermissionsOfUser) {
    // TODO: implement loadLocalPermissionsOfUser
    throw UnimplementedError();
  }

  @override
  Future<Unit> SaveFeaturesOfMaster(List<FeaturePermissionsModel> models) async{
    await securePermissionStore.savePermissionsList(models, Duration(hours: 1));
    return unit;

  }
  }