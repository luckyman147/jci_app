import '../../domain/Dtos/CheckPermissionDtos.dart';
import '../../domain/Dtos/LoadPermission.dart';
import '../Models/FeaturePermissionsModel.dart';

abstract class LocalDataSources{
  Future<FeaturePermissionsModel> loadLocalPermissionsOfUser(LoadPermissionsOfUser loadPermissionsOfUser);
  Future<FeaturePermissionsModel>loadLocalPermissionsOfMaster(
      List<String> featureIds);
  Future<bool?> checkLocaledPermission(CheckPermissionDtos checkPermissionDtos);



}
class LocalPermissionsDataSources implements LocalDataSources{
  @override
  Future<bool?> checkLocaledPermission(CheckPermissionDtos checkPermissionDtos) {
    // TODO: implement checkLocaledPermission
    throw UnimplementedError();
  }

  @override
  Future<FeaturePermissionsModel> loadLocalPermissionsOfMaster(List<String> featureIds) {
    // TODO: implement loadLocalPermissionsOfMaster
    throw UnimplementedError();
  }

  @override
  Future<FeaturePermissionsModel> loadLocalPermissionsOfUser(LoadPermissionsOfUser loadPermissionsOfUser) {
    // TODO: implement loadLocalPermissionsOfUser
    throw UnimplementedError();
  }
  }