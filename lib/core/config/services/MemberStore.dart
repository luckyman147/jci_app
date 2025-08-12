import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../MemberModel.dart';
import '../../PrimitiveUser/UserModel.dart';

class MemberStore {
  final Box box = Hive.box('memberBox');

  static const String _cachedMembersKey = 'CachedMembers';
  static const String _cachedMembersRankKey = 'CachedMembersWithRanks';
  static const String _userInfoKey = 'UserInfo';
  static const String _userPrimInfoKey = 'UserPrimInfo';
  static const String _memberRankKey = 'MemberRank';

  static String _memberID(String id) => 'Member_$id';

  // Cache list of primitive users
  static Future<void> cacheMembers(List<UserModel> members) async {
    final encoded = members.map((e) => e.toJson(true)).toList();
    Hive.box('memberBox').put(_cachedMembersKey, jsonEncode(encoded));
  }

  // Retrieve primitive user list
  static Future<List<UserModel>> getCachedMembers() async {
    final data = Hive.box('memberBox').get(_cachedMembersKey);
    if (data != null) {
      final decoded = jsonDecode(data);
      return (decoded as List).map<UserModel>((e) => UserModel.fromJson(e, true)).toList();
    }
    return [];
  }

  // Cache members with ranks
  static Future<void> cacheMembersWithRanks(List<MemberModel> members) async {
    final encoded = members.map((e) => e.toJson()).toList();
    Hive.box('memberBox').put(_cachedMembersRankKey, jsonEncode(encoded));
  }

  // Get members with ranks
  static Future<List<MemberModel>> getCachedMembersWithRanks() async {
    final data = Hive.box('memberBox').get(_cachedMembersRankKey);
    if (data != null) {
      final decoded = jsonDecode(data);
      return (decoded as List).map<MemberModel>((e) => MemberModel.fromJson(e)).toList();
    }
    return [];
  }

  // Cache member rank
  static Future<void> cacheMemberRank(MemberModel member) async {
    final encoded = jsonEncode(member.toJson());
    Hive.box('memberBox').put(_memberRankKey, encoded);
  }

  // Get cached member rank
  static Future<MemberModel?> getCachedMemberRank() async {
    final data = Hive.box('memberBox').get(_memberRankKey);
    if (data != null) {
      return MemberModel.fromJson(jsonDecode(data));
    }
    return null;
  }

  // Save main MemberModel
  Future<void> saveModel(MemberModel member) async {
    final encoded = jsonEncode(member.toJson());
    box.put(_userInfoKey, encoded);
  }

  // Save primitive UserModel
  Future<void> savePrimitiveModel(UserModel user) async {
    final encoded = jsonEncode(user.toJson(true));
    box.put(_userPrimInfoKey, encoded);
  }

  // Get primitive UserModel
  Future<UserModel> getPrimitiveModel() async {
    final data = box.get(_userPrimInfoKey);
    if (data == null || data.isEmpty) {
      throw Exception('No user found');
    }
    return UserModel.fromJson(jsonDecode(data), true);
  }

  // Get main MemberModel
  Future<MemberModel?> getModel() async {
    final data = box.get(_userInfoKey);
    if (data == null || data.isEmpty) return null;
    return MemberModel.fromJson(jsonDecode(data));
  }

  // Clear main MemberModel
  Future<void> clearModel() async {
    await box.delete(_userInfoKey);
  }

  // Save MemberModel by ID
  Future<Unit> saveMemberByID(MemberModel member, String id) async {
    final encoded = jsonEncode(member.toJson());
    box.put(_memberID(id), encoded);
    return unit;
  }

  // Get MemberModel by ID
  Future<MemberModel?> getMemberByID(String id) async {
    final data = box.get(_memberID(id));
    if (data == null || data.isEmpty) return null;
    return MemberModel.fromJson(jsonDecode(data));
  }

  // Clear MemberModel by ID
  Future<void> clearMemberByID(String id) async {
    await box.delete(_memberID(id));
  }

  // Clear cached members list
  static Future<void> clearCache() async {
    await Hive.box('memberBox').delete(_cachedMembersKey);
  }

  // Clear all data
  Future<void> clearAll() async {
    await box.clear();
  }
}
