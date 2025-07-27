import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/Models/RoleModel.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';
import 'package:jci_app/core/config/env/Constants.dart';

class RoleSeeder {
  final FirebaseFirestore firestore;
  final Faker faker = Faker();
  final rolesCategory={
    CibleType.Members:["Member"],
    CibleType.NewMembers:["New Member"],
    CibleType.VPs:["VPPRE","VPFD","Tresorier","Secretaire Génerale"],
    CibleType.President:["President"],
    CibleType.Advisors:["Media Advisor","Executif Advisor","Recompense Advisor","Rh","tresorier"],



  };
  RoleSeeder(this.firestore);

  Future<void> seedRoles({int count = 10}) async {
    final batch = firestore.batch();
    final rolesCollection = firestore.collection('roles');

    for (int i = 0; i < count; i++) {
      final roleId = firestore.collection('roles').doc().id;
      final roleRef = rolesCollection.doc(roleId);
      final (cibleType, roleType) = getRandomRole();
final role=RoleModel(permissions: _generateRandomPermissions(),
    RoleCategory: cibleType,
    roleName: roleType, id:roleId );
      batch.set(roleRef, role.toJson());
    }

    await batch.commit();
  }

  (CibleType, String) getRandomRole() {
    if (rolesCategory.isEmpty) {
      throw StateError('rolesCategory cannot be empty');
    }

    // Get random CibleType
    final randomCibleType = faker.randomGenerator.element(rolesCategory.keys.toList());

    // Get roles for selected CibleType
    final roles = rolesCategory[randomCibleType]!;

    // Get random role from the list
    final randomRole = faker.randomGenerator.element(roles);

    return (randomCibleType, randomRole);
  }
 List<FeaturePermissions> _generateRandomPermissions() {
    return [

      FeaturePermissions(featureId: Constants.MANAGE_POINTS,
permissions:[
  for (int i = 0; i < PermissionType.values.length; i++)
    Permission(
        type: PermissionType.values[i],
        isGranted: faker.randomGenerator.boolean()
    )

]),
      FeaturePermissions(featureId: Constants.MANAGE_MEMBERS,
permissions:[
  for (int i = 0; i < PermissionType.values.length; i++)
    Permission(
        type: PermissionType.values[i],
        isGranted: faker.randomGenerator.boolean()
    )

]),
      FeaturePermissions(featureId: Constants.MANAGE_OBJECTIFS,
permissions:[
  for (int i = 0; i < PermissionType.values.length; i++)
    Permission(
        type: PermissionType.values[i],
        isGranted: faker.randomGenerator.boolean()
    )

]),

      FeaturePermissions(featureId: Constants.MANAGE_EVENTS,
          permissions:[
            for (int i = 0; i < PermissionType.values.length; i++)
              Permission(
                  type: PermissionType.values[i],
                  isGranted: faker.randomGenerator.boolean()
              )

          ]), FeaturePermissions(featureId: Constants.MANAGE_MEETINGS,
          permissions:[
            for (int i = 0; i < PermissionType.values.length; i++)
              Permission(
                  type: PermissionType.values[i],
                  isGranted: faker.randomGenerator.boolean()
              )

          ]),

      FeaturePermissions(featureId: Constants.MANAGE_TRAININGS,
          permissions:[
            for (int i = 0; i < PermissionType.values.length; i++)
              Permission(
                  type: PermissionType.values[i],
                  isGranted: faker.randomGenerator.boolean()
              )

          ]),
    ];
  }

  Future<void> clearRoles() async {
    final query = await firestore.collection('roles').get();
    final batch = firestore.batch();

    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
    print('All roles cleared');
  }
}