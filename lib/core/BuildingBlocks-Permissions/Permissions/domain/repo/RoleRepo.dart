import 'package:dartz/dartz.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';

import '../../../../error/Failure.dart';
import '../Dtos/RolePermissionsDto.dart';

abstract class RoleRepo{



  Future<Either<Failure,Unit>> CreateRole(Role role);
  Future<Either<Failure,Unit>> UpdateRoleInfos(Role role);
  Future<Either<Failure,Unit>> UpdateRolePermissions(RolePermissionsDto rolePermissionDto);
  Future<Either<Failure,Unit>> ChangeRoleOfUser(String userId, String roleId) ;

  Future<Either<Failure,List<Role>>> FetchRoles();
  Future<Either<Failure,Role>> FetchRoleByName (String roleName);



}