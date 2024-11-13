import 'package:dartz/dartz.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/DataSources/LocalPermissionsDataSources.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/DataSources/RemotePermissionsDataSources.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Models/UserPermissionsModel.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Dtos/CheckPermissionDtos.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Dtos/LoadPermission.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Dtos/TempoPermissions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/UserPermissions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/repo/PermissionsRepositories.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/core/error/Failure.dart';

class PemissionsRepoImpl implements PermissionsRepository     {
  final RemoteDataSources remoteDataSources;
  final LocalDataSources localDataSources;
  final Handler<Unit> unitHandler;
  final Handler<bool> boolHandler;
  final Handler<FeaturePermissions> featurePermissionsHandler;

  PemissionsRepoImpl({required this.remoteDataSources, required this.localDataSources, required this.unitHandler, required this.boolHandler, required this.featurePermissionsHandler});
  @override
  Future<Either<Failure, Unit>> addTemporaryPermissions(TempoPermissions tempoPermissions) async{
  return await unitHandler.handle(onCall: () {
    return remoteDataSources.addTemporaryPermissions(tempoPermissions);
  },

      onError: (error) {
    if (error is Exception) {
      return error.get_failure;

    }
    throw error;
      });
  }

  @override
  Future<Either<Failure, bool>> checkPermission(CheckPermissionDtos checkPermissionDtos)async {
    final local=await localDataSources.checkLocaledPermission(checkPermissionDtos);

    return  boolHandler.handle(onCall: () async{

      if(local!=null)
      {
        return local;
      }
      return remoteDataSources.checkPermission(checkPermissionDtos);

    }, onError: (error) {

      if (error is Exception) {
        return error.get_failure;

      }
      throw error;

    },
    onFailConnection: ()async{
      if (local!=null) {
        return local;
      }
      throw OfflineException ();


    }
    );
  }

  @override
  Future<Either<Failure, FeaturePermissions>> loadPermissionsOfMaster(List<String> featureIds) async{
    final local=await localDataSources.loadLocalPermissionsOfMaster(featureIds);

    return await featurePermissionsHandler.handle(onCall: ()async {
      if(local!=null)
      {
        return local;
      }

      return remoteDataSources.loadPermissionsOfMaster(featureIds);
    }, onError: (error) {
      if (error is Exception) {
        return error.get_failure;
      }
      throw error;
    }
    ,
      onFailConnection:
      ()async{
        if (local!=null) {
          return local;
        }
       throw OfflineException();
      }
    );


  }

  @override
  Future<Either<Failure, FeaturePermissions>> loadPermissionsOfUser(LoadPermissionsOfUser loadPermissionsOfUser) async{
    final local=await localDataSources.loadLocalPermissionsOfUser(loadPermissionsOfUser);

    return await featurePermissionsHandler.handle(onCall: ()async {
      if(local!=null)
      {
        return local;
      }

      return remoteDataSources.loadPermissionsOfUser(loadPermissionsOfUser);
    }, onError: (error) {
      if (error is Exception) {
        return error.get_failure;
      }
      throw error;
    }
    ,
      onFailConnection:
      ()async{
        if (local!=null) {
          return local;
        }
        throw OfflineException();
      }
    );
  }

  @override
  Future<Either<Failure, Unit>> updatePermissions(UserPermissions userPermissions) async{
    return await unitHandler.handle(onCall: () {
      final model=UserPermissionsModel.fromEntity(userPermissions);
      return remoteDataSources.updatePermissions(model);
    },

      onError: (error) {
      if (error is Exception) {
        return error.get_failure;

      }
      throw error;
      });

  }
}