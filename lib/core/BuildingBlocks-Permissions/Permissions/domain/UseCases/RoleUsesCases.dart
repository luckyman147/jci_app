import 'package:dartz/dartz.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/repo/RoleRepo.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';

import '../Dtos/RolePermissionsDto.dart';
import '../Entities/Role.dart';

class CreateRoleUsesCase extends UseCase<Unit,Role >{
  final RoleRepo roleRepo;

  CreateRoleUsesCase({required this.roleRepo});
  @override
  Future<Either<Failure, Unit>> call(Role params)async {
    return await roleRepo.CreateRole(params);
  }
}class UpdateRoleInfoUseCase extends UseCase<Unit, Role> {
  final RoleRepo roleRepo;

  UpdateRoleInfoUseCase({required this.roleRepo});

  @override
  Future<Either<Failure, Unit>> call(Role params) async {
    try {
      return await roleRepo.UpdateRoleInfos(params);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}class UpdateRolePermissionsUseCase extends UseCase<Unit, RolePermissionsDto> {
  final RoleRepo roleRepo;

  UpdateRolePermissionsUseCase({required this.roleRepo});

  @override
  Future<Either<Failure, Unit>> call(RolePermissionsDto params) async {
    try {

      return await roleRepo.UpdateRolePermissions(params);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}class ChangeRoleOfUserUseCase extends UseCase<Unit, ChangeRoleParams> {
  final RoleRepo roleRepo;

  ChangeRoleOfUserUseCase({required this.roleRepo});

  @override
  Future<Either<Failure, Unit>> call(ChangeRoleParams params) async {
    try {

      return await roleRepo.ChangeRoleOfUser(params.userId, params.roleId);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}class FetchRolesUseCase extends UseCase<List<Role>, NoParams> {
  final RoleRepo roleRepo;

  FetchRolesUseCase({required this.roleRepo});

  @override
  Future<Either<Failure, List<Role>>> call(NoParams params) async {
    try {
      return await roleRepo.FetchRoles();
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

class FetchRoleByNameUseCase extends UseCase<Role, String> {
  final RoleRepo roleRepo;

  FetchRoleByNameUseCase({required this.roleRepo});

  @override
  Future<Either<Failure, Role>> call(String params) async {
    return await roleRepo.FetchRoleByName(params);
  }
}
class ChangeRoleParams {
  final String userId;
  final String roleId;

  ChangeRoleParams({required this.userId, required this.roleId});
}