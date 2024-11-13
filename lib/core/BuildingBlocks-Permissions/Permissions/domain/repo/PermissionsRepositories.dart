// permissions_repository.dart
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';

import '../Dtos/CheckPermissionDtos.dart';
import '../Dtos/LoadPermission.dart';
import '../Dtos/TempoPermissions.dart';
import '../Entities/FeaturePermissions.dart';
import '../Entities/UserPermissions.dart';

abstract class PermissionsRepository {
  /// Loads permissions for a specific user and a list of feature IDs.
  ///
  /// [userId] - The ID of the user to load permissions for.
  /// [featureIds] - A list of feature IDs to retrieve permissions for.
  ///
  /// Returns a map where each feature ID is associated with its specific permissions.
  Future<Either<Failure,FeaturePermissions>> loadPermissionsOfUser(
      LoadPermissionsOfUser loadPermissionsOfUser);

  /// Loads permissions of the current master user.
  ///
  /// [userId] - The ID of the master user.
  /// [featureIds] - A list of feature IDs to retrieve permissions for.
  ///
  /// Returns a map where each feature ID is associated with its specific permissions.
  Future<Either<Failure,FeaturePermissions>>loadPermissionsOfMaster(
       List<String> featureIds);

  /// Checks if a specific permission is granted for a feature.
  ///
  /// [featureId] - The ID of the feature to check permissions for.
  /// [permissionType] - The specific permission type (e.g., "canRead", "canWrite").
  ///
  /// Returns `true` if the permission is granted, `false` otherwise.
  Future<Either<Failure,bool>> checkPermission(CheckPermissionDtos checkPermissionDtos);

  /// Updates permissions for a specific role or feature.
  ///
  /// [roleId] - The ID of the role to update permissions for.
  /// [featureId] - The ID of the feature to update permissions for.
  /// [newPermissions] - A map of permission types (e.g., "canRead", "canWrite") to boolean values indicating access.
  Future<Either<Failure,Unit>> updatePermissions(UserPermissions userPermissions);
/// Creates a new role with specific permissions.
  /// [RoleName ] - The name of the role to create.
  /// [Features] - List of features
  ///

  ///Future<void> CreateRole(CreateRoleDtos createRoleDtos);
  /// Adds temporary permissions for a specific user and feature, with an expiration time.
  ///
  /// [userId] - The ID of the user to add temporary permissions for.
  /// [featureId] - The ID of the feature for which temporary permissions are added.
  /// [temporaryPermissions] - A map of permission types to boolean values.
  /// [expiry] - The date and time when the temporary permissions will expire.
  ///
  /// This method adds or overrides specific permissions for a feature, which are valid until the specified expiry time.
  Future<Either<Failure,Unit>> addTemporaryPermissions(
     TempoPermissions tempoPermissions);

}
