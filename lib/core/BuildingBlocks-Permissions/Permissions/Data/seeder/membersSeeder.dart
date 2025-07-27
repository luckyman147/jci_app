import 'package:faker/faker.dart';
import 'package:jci_app/core/MemberModel.dart';

import '../../../../Member.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MemberSeeder {
  static final _faker = Faker();
  static final _firestore = FirebaseFirestore.instance;

  // Generate a single random member with DocumentReference role
  static Member generateMember({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? roleName,
    double? points,
    int? rank,
    bool? isValidated,
    List<dynamic>? images,
    DocumentReference? role, // Added DocumentReference parameter
  }) {
    return Member(
      id: id ?? _faker.guid.guid(),
      firstName: firstName ?? _faker.person.firstName(),
      lastName: lastName ?? _faker.person.lastName(),
      email: email ?? _faker.internet.email(),
      phone: phone ?? _faker.phoneNumber.us(),
      roleName: roleName ??
          _faker.randomGenerator.element(['Member', 'New Member', 'President']),
      points: points ?? _faker.randomGenerator.decimal(),
      PreviousPoints: _faker.randomGenerator.decimal(),
      rank: rank ?? _faker.randomGenerator.integer(10),
      is_validated: isValidated ?? _faker.randomGenerator.boolean(),
      description: _faker.lorem.sentence(),
      board: _faker.randomGenerator
          .element(['President', 'VP', 'Secretary', null]),
      language: _faker.randomGenerator.element(['en', 'fr', 'ar']),
      cotisation: List.generate(2, (_) => _faker.randomGenerator.boolean()),
      Activities: List.generate(3, (_) => _faker.randomGenerator.string(10)),
      teams: List.generate(2, (_) => _faker.randomGenerator.string(10)),
      Images: images ??
          [
            _faker.image.image(width: 200, height: 200),
          ],
      role: role ??
          _firestore
              .collection('roles')
              .doc(), // Generate random role reference
      IsSelected: false,
      isEmailVerified: true,
      userObjectifs: [],
      notificationCount: _faker.randomGenerator.integer(10),
      unreadNotificationCount: _faker.randomGenerator.integer(5),
    );
  }

  // Generate with specific role reference
  static Future<Member> generateMemberWithRole(String roleId) async {
    final roleRef = _firestore.collection('roles').doc(roleId);
    return generateMember(role: roleRef);
  }

  // Generate list with role references
  static Future<List<Member>> generateMembersWithRoles({int count = 1}) async {
    final rolesSnapshot =
        await _firestore.collection('roles').limit(count).get();
    return List.generate(count, (index) {
      final roleRef = index < rolesSnapshot.docs.length
          ? rolesSnapshot.docs[index].reference
          : _firestore.collection('roles').doc();
      return generateMember(role: roleRef);
    });
  }

  // Alternative: Insert one by one with delay (for testing)
  static Future<void> seedMembersOneByOne() async {
    final members = await MemberSeeder.generateMembersWithRoles(count: 10);

    for (final member in members) {
      await _firestore
          .collection('users')
          .doc(member.id)
          .set(MemberModel.fromEntity(member).toJson());
      await Future.delayed(const Duration(milliseconds: 200)); // Throttle
    }
  }
}
