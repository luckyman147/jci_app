import 'package:dartz/dartz.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/DataSources/RoleRemoteDatasources.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Models/RoleModel.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Dtos/RolePermissionsDto.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/repo/RoleRepo.dart';
import 'package:jci_app/core/error/Failure.dart';

import '../../../../Handlers/Handler.dart';

class RoleRepoImpl implements RoleRepo{

  final RoleRemoteDataSources roleRemoteDataSources;
  final Handler<Unit> handler;
  final Handler<Role> rolehandler;
  final Handler<List<Role>> roleshandler;

  RoleRepoImpl({required this.roleRemoteDataSources, required this.handler, required this.rolehandler, required this.roleshandler});

  @override
  Future<Either<Failure, Unit>> CreateRole(Role role) async{
    return await handler.handle(onCall: ()async{
      await roleRemoteDataSources.CreateRole(RoleModel.fromEntity(role));
      return unit;




    }, onError: (e){

      if (e is Exception) throw e;

    });

  }

  @override
  Future<Either<Failure, List<Role>>> FetchRoles() async{
    return await roleshandler.handle(onCall: ()async{
   return   await roleRemoteDataSources.FetchRoles();





    }, onError: (e){

      if (e is Exception) throw e;

    });

  }

  @override
  Future<Either<Failure, Unit>> UpdateRoleInfos(Role role) async{
    return await handler.handle(onCall: ()async{
      await roleRemoteDataSources.UpdateRoleInfos(RoleModel.fromEntity(role));
      return unit;




    }, onError: (e){

      if (e is Exception) throw e;

    });

  }

  @override
  Future<Either<Failure, Unit>> UpdateRolePermissions(RolePermissionsDto rolePermissionDto) async{
    return await handler.handle(onCall: ()async{
      await roleRemoteDataSources.UpdateRolePermissions(rolePermissionDto);
      return unit;
    }, onError: (e){
      if (e is Exception) throw e;
    });

  }

  @override
  Future<Either<Failure, Unit>> ChangeRoleOfUser(String userId, String roleId)async {
    return await handler.handle(onCall: ()async{
      await roleRemoteDataSources.ChangeRoleOfUser(userId,roleId);
      return unit;




    }, onError: (e){

      if (e is Exception) throw e;

    });

  }

  @override
  Future<Either<Failure, Role>> FetchRoleByName(String roleId)async {
    return await rolehandler.handle(onCall: ()async{
      return await roleRemoteDataSources.FetchRoleByName(roleId);





    }, onError: (e){

      if (e is Exception) throw e;

    });

  }
}