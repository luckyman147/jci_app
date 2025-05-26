import 'package:dartz/dartz.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Models/FeatureModel.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Models/FeaturePermissionsModel.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Dtos/LoadPermission.dart';
import 'package:jci_app/core/error/Exception.dart';

import '../../../../../features/auth/AuthWidgetGlobal.dart';
import '../../domain/Dtos/CheckPermissionDtos.dart';
import '../../domain/Dtos/TempoPermissions.dart';
import '../Models/UserPermissionsModel.dart';

abstract class RemoteDataSources{
  Future<List<FeaturePermissionsModel>> loadPermissionsOfUser(LoadPermissionsOfUser loadPermissionsOfUser);
  Future<List<FeaturePermissionsModel>>loadPermissionsOfMaster(
      List<String> featureIds);
  Future<bool> checkPermission(CheckPermissionDtos checkPermissionDtos);
  Future<Unit> updatePermissions(UserPermissionsModel userPermissions);
Future<List<FeaturePermissionsModel>> AddMisingFeature(List<String> missingFeaturesId,List<FeaturePermissionsModel> OriginalList);
  Future<Unit> addTemporaryPermissions(
      TempoPermissions tempoPermissions);
  Future<List<FeatureModel>> fetchFeatures();

}
class RemotePermissionsDataSourcesImpl implements RemoteDataSources {
  final FirebaseFirestore firestore ;
    final FirebaseAuth auth;
  final Logger logger ;  // Using the Logger package for logging
  RemotePermissionsDataSourcesImpl(this.auth, this.logger, {required this.firestore});
  @override
  Future<Unit> addTemporaryPermissions(TempoPermissions tempoPermissions) {
    // TODO: implement addTemporaryPermissions
    throw UnimplementedError();
  }

  @override
  Future<bool> checkPermission(CheckPermissionDtos checkPermissionDtos)async {
try{
  final userId = auth.currentUser!.uid;
  FeaturePermissionsModel permissions = await _ExtractFeaturesById(userId, checkPermissionDtos);
  final permission = permissions.permissions.firstWhere((element) => element.type==checkPermissionDtos.permissionType.toString());
  return permission.isGranted;

}on FirebaseException catch (e) {

  logger.e("Firebase error: ${e.message}");
  throw NotFoundException();
} catch (e, stacktrace) {
  // Handle any other errors
  logger.e("Unexpected error: $e\nStacktrace: $stacktrace");
throw ServerException();
}
  }





  @override
  Future<List<FeaturePermissionsModel>> loadPermissionsOfMaster(List<String> featureIds) async {
    List<FeaturePermissionsModel> featurePermissionsList = [];

    try {
      final userId = auth.currentUser!.uid;
      final userDoc = await firestore.collection("users").doc(userId).get();
      final roleRef = userDoc["role"] as DocumentReference;

      // Fetch permissions from the role document
      final roleData = await roleRef.get();

      // Get the data of the role document as a Map
      final roleMap = roleData.data() as Map<String, dynamic>;

      // Check if 'permissions' exists in the role data
      if (roleMap.containsKey('permissions')) {
        final permissions = roleMap['permissions'] as Map<String, dynamic>;


        for (var featureId in featureIds) {
          // Check if the featureId exists in the 'permissions' map
          if (permissions.containsKey(featureId)) {
            Map<String, dynamic>    featureData = permissions[featureId] ;

            var featurePermissions = FeaturePermissionsModel.fromMap(featureId, featureData);
            featurePermissionsList.add(featurePermissions);
          }
        }
      }
    } catch (e) {
      Logger().e("Error loading permissions: $e");
      rethrow;
    }

    return featurePermissionsList;
  }


  @override
  Future<List<FeaturePermissionsModel>> loadPermissionsOfUser(LoadPermissionsOfUser loadPermissionsOfUser) {
    // TODO: implement loadPermissionsOfUser
    throw UnimplementedError();
  }

  @override
  Future<Unit> updatePermissions(UserPermissionsModel userPermissions) {
    // TODO: implement updatePermissions
    throw UnimplementedError();
  }
  Future<FeaturePermissionsModel> _ExtractFeaturesById(String userId, CheckPermissionDtos checkPermissionDtos) async {
    final userDoc = await firestore.collection("users").doc(userId).get();
    final roleRef = userDoc["role"] as DocumentReference;

    // Fetch permissions from the role document
    final roleDoc = await roleRef.get();
    final permissionsJson = roleDoc["permissions"][checkPermissionDtos.featureId] ;
    final permissions=FeaturePermissionsModel.fromMap(checkPermissionDtos.featureId,permissionsJson);
    return permissions;
  }

  @override
  Future<List<FeaturePermissionsModel>> AddMisingFeature(List<String> missingFeaturesId, List<FeaturePermissionsModel> originalList) async{

    // Fetch missing permissions from API

      List<FeaturePermissionsModel> fetchedPermissions =
          await loadPermissionsOfMaster(missingFeaturesId);

      // Merge new permissions with existing ones
      originalList.addAll(fetchedPermissions);
return originalList;



  }


  @override
  Future<List<FeatureModel>> fetchFeatures() async {
    try {
      // Get reference to the features collection
      final collection = FirebaseFirestore.instance.collection('features');

      // Get documents from Firestore
      final querySnapshot = await collection.get();

      // Convert documents to FeatureModel objects
      final features = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return FeatureModel.fromMap(data);
      }).toList();

      return features;
    } catch (e) {
logger.e(e.toString());
throw ServerException();
    }
  }
}