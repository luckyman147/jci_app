import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Dtos/RolePermissionsDto.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../error/Exception.dart';

import '../Models/FeaturePermissionsModel.dart';
import '../Models/RoleModel.dart';

abstract class RoleRemoteDataSources {
  Future<Unit> CreateRole(RoleModel role);
  Future<Unit> UpdateRoleInfos(RoleModel role);
  Future<Unit> UpdateRolePermissions(RolePermissionsDto permissions);
  Future<Unit> ChangeRoleOfUser(String Userid, String roleId);
  Future<List<RoleModel>> FetchRoles();
  Future<RoleModel> FetchRoleByName(String RoleName);
}

class RoleRemoteDataSourceImpl implements RoleRemoteDataSources {
  final FirebaseFirestore firestore;
  final Logger logger;
  static const String _collectionName = 'roles';

  RoleRemoteDataSourceImpl({
    required this.logger,
    required this.firestore,
  });
  @override
  Future<Unit> CreateRole(RoleModel role) async {
    try {
      // First check if role name already exists
      final querySnapshot = await firestore
          .collection(_collectionName)
          .where('roleName', isEqualTo: role.roleName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw AlreadyParticipateException();
      }

      // If not exists, proceed with creation
      final ref = firestore.collection(_collectionName).doc();
      await ref.set(role.toJson());
      await ref.update({'id': ref.id});

      return unit;
    } on FirebaseException catch (e) {
      logger.e('Failed to create role: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<List<RoleModel>> FetchRoles() async {
    try {
      // Fetch roles and features in parallel
      final rolesSnapshot = await firestore.collection(_collectionName).get();
      final featuresSnapshot = await firestore.collection('features').get();

      // Convert features to a map for easy lookup
      final featuresMap = {
        for (var doc in featuresSnapshot.docs)
          doc.id: (doc.data()['featureName'] as String)
              .trim() // Assuming 'name' is the field
      };

      return rolesSnapshot.docs.map((doc) {
        final data = doc.data();
        final role = RoleModel.fromPermissionsMap(data);

        // Enhance permissions with feature names
        final enhancedPermissions = role.permissions.map((permission) {
          logger.wtf(permission.featureId);
          final featureName = featuresMap[permission.featureId];
          return permission.CopyWith(featureName);
        }).toList();

        return role.copyWith(permissions: enhancedPermissions);
      }).toList();
    } on FirebaseException catch (e) {
      logger.e('Failed to fetch roles: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<Unit> UpdateRoleInfos(RoleModel role) async {
    try {
      await firestore
          .collection(_collectionName)
          .doc(role.id)
          .update(role.toJson());
      return unit;
    } on FirebaseException catch (e) {
      logger.e('Failed to update role info: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<Unit> UpdateRolePermissions(RolePermissionsDto permissions) async {
    try {
      await firestore
          .collection(_collectionName)
          .doc(permissions.roleId)
          .update({
        'permissions': permissions.permissions.map(
            (elemet) => FeaturePermissionsModel.fromEntity(elemet).toMap()),
      });
      return unit;
    } on FirebaseException catch (e) {
      logger.e('Failed to update role permissions: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<Unit> ChangeRoleOfUser(String userId, String roleId) async {
    try {
      // Get references to both documents
      final userRef = firestore.collection('users').doc(userId);
      final roleRef = firestore.collection('roles').doc(roleId);

      // Verify both documents exist
      final results = await Future.wait([userRef.get(), roleRef.get()]);

      if (!results[0].exists) {
        throw NotFoundException();
      }
      if (!results[1].exists) {
        throw NotFoundException();
      }

      // Update user's role reference in a transaction
      await firestore.runTransaction((transaction) async {
        transaction.update(userRef, {
          'role': roleRef, // Store the DocumentReference
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });

      return unit;
    } on FirebaseException catch (e) {
      logger.e('Failed to change user role: ${e.message}');
      throw ServerException();
    }
  }

  @override
  Future<RoleModel> FetchRoleByName(String roleName) async {
    try {
      // Perform case-insensitive search by storing lowercase versions
      final querySnapshot = await firestore
          .collection('roles')
          .where('roleName', isEqualTo: roleName.toLowerCase())
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw NotFoundException();
      }

      // Get the first matching document
      final roleDoc = querySnapshot.docs.first;
      final data = roleDoc.data();

      return RoleModel.fromPermissionsMap(data);
    } on FirebaseException catch (e) {
      logger.e('Failed to fetch role by name: ${e.message}');
      throw ServerException();
    }
  }
}
