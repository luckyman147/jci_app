part of 'features_cubit.dart';
enum TypeFeatureStatus { Initial, Loading, Loaded, Error,  }

 class FeaturesState extends Equatable {
  const FeaturesState({ this.features=const[],
    this.featuresModified=const [],
  this.typeFeatureStatus=TypeFeatureStatus.Initial

  });
  final List<Feature> features;
  final List<Feature> featuresModified;
  final TypeFeatureStatus typeFeatureStatus;


  FeaturesState copyWith({List<Feature> ?features ,List<Feature> ?featuresModified,TypeFeatureStatus?

  typeFeaturesStatus}){
    return FeaturesState(
     features: features??this.features,
     featuresModified: featuresModified??this.featuresModified,
     typeFeatureStatus: typeFeaturesStatus??this.typeFeatureStatus
    );
  }
  bool havePermissionsChanged() {
    // If lengths are different, permissions have definitely changed
    if (features.length != featuresModified.length) return true;

    for (int i = 0; i < features.length; i++) {
      final originalFeature = features[i];
      final modifiedFeature = featuresModified[i];

      // Check if the number of permissions changed
      if (originalFeature.permissions.length != modifiedFeature.permissions.length) {
        return true;
      }

      // Compare each permission's isGranted status
      for (int j = 0; j < originalFeature.permissions.length; j++) {
        if (originalFeature.permissions[j].isGranted !=
            modifiedFeature.permissions[j].isGranted) {
          return true;
        }
      }
    }

    return false;
  }
  @override
  // TODO: implement props
  List<Object?> get props => [features,typeFeatureStatus,featuresModified];

 }

final class FeaturesInitial extends FeaturesState {
  @override
  List<Object> get props => [];
}
