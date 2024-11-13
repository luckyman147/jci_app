import 'package:dartz/dartz.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Models/FeaturePermissionsModel.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Dtos/LoadPermission.dart';

import '../../domain/Dtos/CheckPermissionDtos.dart';
import '../../domain/Dtos/TempoPermissions.dart';
import '../Models/UserPermissionsModel.dart';

abstract class RemoteDataSources{
  Future<FeaturePermissionsModel> loadPermissionsOfUser(LoadPermissionsOfUser loadPermissionsOfUser);
  Future<FeaturePermissionsModel>loadPermissionsOfMaster(
      List<String> featureIds);
  Future<bool> checkPermission(CheckPermissionDtos checkPermissionDtos);
  Future<Unit> updatePermissions(UserPermissionsModel userPermissions);

  Future<Unit> addTemporaryPermissions(
      TempoPermissions tempoPermissions);

}
class RemoteDataSourcesImpl implements RemoteDataSources {
  @override
  Future<Unit> addTemporaryPermissions(TempoPermissions tempoPermissions) {
    // TODO: implement addTemporaryPermissions
    throw UnimplementedError();
  }

  @override
  Future<bool> checkPermission(CheckPermissionDtos checkPermissionDtos) {
    // TODO: implement checkPermission
    throw UnimplementedError();
  }

  @override
  Future<FeaturePermissionsModel> loadPermissionsOfMaster(List<String> featureIds) {
    // TODO: implement loadPermissionsOfMaster
    throw UnimplementedError();
  }

  @override
  Future<FeaturePermissionsModel> loadPermissionsOfUser(LoadPermissionsOfUser loadPermissionsOfUser) {
    // TODO: implement loadPermissionsOfUser
    throw UnimplementedError();
  }

  @override
  Future<Unit> updatePermissions(UserPermissionsModel userPermissions) {
    // TODO: implement updatePermissions
    throw UnimplementedError();
  }
}