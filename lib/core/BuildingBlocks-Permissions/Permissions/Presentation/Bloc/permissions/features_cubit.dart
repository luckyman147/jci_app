import 'package:bloc/bloc.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';

import '../../../../../error/Failure.dart';
import '../../../../../usescases/usecase.dart';
import '../../../domain/Entities/Feature.dart';
import '../../../domain/UseCases/PermissionsUseCases.dart';

part 'features_state.dart';

class FeaturesCubit extends Cubit<FeaturesState> {
  FeaturesCubit(this.featuresUsesCases) : super(FeaturesInitial());
  final FetchFeaturesUsesCases featuresUsesCases;

  Future<void> fetchFeatures() async {
    if (state.features.isNotEmpty && state.featuresModified.isNotEmpty) {
      emit(state.copyWith(
          typeFeaturesStatus: TypeFeatureStatus.Loaded,
          featuresModified: state.featuresModified));
    } else {
      emit(state.copyWith(typeFeaturesStatus: TypeFeatureStatus.Loading));
      final data = await featuresUsesCases.call(NoParams());

      // Emit the new state
      emit(EithFailureorResponse<List<Feature>>(
        data,
        (res) {
          return state.copyWith(
              featuresModified: res,
              features: res,
              typeFeaturesStatus: TypeFeatureStatus.Loaded);
        },
      ));
    }
  }

  void FromRolePermissions(List<FeaturePermissions> featuresPermissions) {
    emit(state.copyWith(typeFeaturesStatus: TypeFeatureStatus.Loading));

    emit(state.copyWith(
        typeFeaturesStatus: TypeFeatureStatus.Loaded,
        featuresModified:
            updateFeaturesPermissions(state.features, featuresPermissions)));
  }

  void clear_Features() {
    emit(state.copyWith(featuresModified: []));
  }

  Future<void> onTogglePermission(String featureId, PermissionType type) async {
    final updatedFeatures = state.featuresModified.map((feature) {
      if (feature.featureId == featureId) {
        final updatedPermissions = feature.permissions.map((permission) {
          if (permission.type == type) {
            return permission.copyWith(isGranted: !permission.isGranted);
          }
          return permission;
        }).toList();
        return feature.copyWith(permissions: updatedPermissions);
      }
      return feature;
    }).toList();

    emit(state.copyWith(
        featuresModified: updatedFeatures,
        typeFeaturesStatus: TypeFeatureStatus.Loaded));
  }

  FeaturesState EithFailureorResponse<T>(
      Either<Failure, T> response, Function(T) onreturn) {
    return response.fold((failure) {
      return state.copyWith(
        typeFeaturesStatus: TypeFeatureStatus.Error,
      );
    }, (res) {
      return onreturn(res);
    });
  }

  List<Feature> updateFeaturesPermissions(List<Feature> originalFeatures,
      List<FeaturePermissions> permissionsUpdate) {
    return originalFeatures.map((feature) {
      // Find matching permissions update (if any)
      final update = permissionsUpdate.firstWhere(
        (pu) => pu.featureId == feature.featureId,
        orElse: () => FeaturePermissions(
          featureId: feature.featureId,
          permissions: feature.permissions, // Keep original if no update
        ),
      );

      // Return new Feature with updated permissions
      return feature.copyWith(permissions: update.permissions);
    }).toList();
  }
}
