// Use Cases for PermissionsRepository

// Use Case 1: Load Permissions for a User
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';

import '../Dtos/CheckPermissionDtos.dart';
import '../Dtos/LoadPermission.dart';
import '../Dtos/TempoPermissions.dart';
import '../Entities/Feature.dart';
import '../Entities/FeaturePermissions.dart';
import '../Entities/UserPermissions.dart';
import '../repo/PermissionsRepositories.dart';

class LoadUserPermissionsUseCase extends UseCase<List< FeaturePermissions>,LoadPermissionsOfUser>{
  final PermissionsRepository permissionsRepository;

  LoadUserPermissionsUseCase(this.permissionsRepository);

  @override
  Future<Either<Failure,List< FeaturePermissions>>> call(LoadPermissionsOfUser params) {
    return permissionsRepository.loadPermissionsOfUser(params);
  }
}

// Use Case 2: Load Permissions for the Master User
class LoadMasterPermissionsUseCase extends UseCase<List< FeaturePermissions>,List<String>>{
  final PermissionsRepository permissionsRepository;

  LoadMasterPermissionsUseCase(this.permissionsRepository);

  @override
  Future<Either<Failure, List< FeaturePermissions>>> call(List<String> params) {
    return permissionsRepository.loadPermissionsOfMaster(params);
  }


}

// Use Case 3: Check Permission for a Feature
class CheckPermissionUseCase extends UseCase<bool,CheckPermissionDtos>{
  final PermissionsRepository permissionsRepository;

  CheckPermissionUseCase(this.permissionsRepository);

  @override
  Future<Either<Failure, bool>> call(CheckPermissionDtos params) {
    return permissionsRepository.checkPermission(params);

  }


}

// Use Case 4: Update Permissions for a User or Role
class UpdateUserPermissionsUseCase extends UseCase<Unit,UserPermissions>{
  final PermissionsRepository permissionsRepository;

  UpdateUserPermissionsUseCase(this.permissionsRepository);

  @override
  Future<Either<Failure, Unit>> call(params) {
    return permissionsRepository.updatePermissions(params);

  }


}



// Use Case 6: Add Temporary Permissions for a User
class AddTemporaryPermissionsUseCase extends UseCase<Unit,TempoPermissions>{
  final PermissionsRepository permissionsRepository;

  AddTemporaryPermissionsUseCase(this.permissionsRepository);

  @override
  Future<Either<Failure, Unit>> call(TempoPermissions params)async {
    return await permissionsRepository.addTemporaryPermissions(params);
  }

}
class FetchFeaturesUsesCases extends UseCase<List<Feature>,NoParams>{
  final PermissionsRepository permissionsRepository;

  FetchFeaturesUsesCases({required this.permissionsRepository});

  @override
  Future<Either<Failure, List<Feature>>> call(NoParams params) async{
    return  await permissionsRepository.loadAllFeatures();
  }

}