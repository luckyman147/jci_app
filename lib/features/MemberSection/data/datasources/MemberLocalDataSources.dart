import 'package:dartz/dartz.dart';

import '../../../../core/config/services/MemberStore.dart';
import '../../../auth/data/models/Member/AuthModel.dart';

abstract class MemberLocalDatasoources{
  Future<MemberModel?> getUserProfile();
  Future<MemberModel?> getMemberById(String id );
  Future<Unit> saveMemberByID(MemberModel member,String id);

  Future<Unit> ChangeUserProfile(MemberModel member);
  Future<List<MemberModel>> GetmMemberByName(
      String name
      );
  Future<List<MemberModel>> GetMembers();
  Future<List<MemberModel>> GetMembersWithRanks();
  Future<MemberModel?> GetMemberWithRanks();


  Future<Unit> CacheMembers(List<MemberModel> members);
  Future<Unit> CacheMemberwithRanks(List<MemberModel> members);
  Future<Unit> CacheMembewithRanks(MemberModel members);




}
class MemberLocalDatasoourcesImpl implements MemberLocalDatasoources {
  @override
  Future<List<MemberModel>> GetMembers()async  {
 final members = MemberStore.getCachedMembers();
    return Future.value(members);
  }

  @override
  Future<List<MemberModel>> GetmMemberByName(String name) {
    // TODO: implement GetmMemberByName
    throw UnimplementedError();
  }

  @override
  Future<MemberModel?> getUserProfile() async {
final member=await MemberStore.getModel();



    return member;
  }

  @override
  Future<Unit> CacheMembers(List<MemberModel> members)async {
    await MemberStore.cacheMembers(members);
    return Future.value(unit);
  }

  @override
  Future<Unit> ChangeUserProfile(MemberModel member)  async {
 await MemberStore.saveModel(member);
    return Future.value(unit);
  }

  @override
  Future<MemberModel?> getMemberById(String id) {
final member= MemberStore.getMemberByID(id);
    return member;
  }

  @override
  Future<Unit> saveMemberByID(MemberModel member, String id) {
    MemberStore.saveMemberBYID(member,id);
    return Future.value(unit);
  }

  @override
  Future<List<MemberModel>> GetMembersWithRanks() {
    final members = MemberStore.getCachedMembersWithRanks();
    return Future.value(members);
  }

  @override
  Future<Unit> CacheMemberwithRanks(List<MemberModel> members) {
    MemberStore.cacheMembersWithRanks(members);
    return Future.value(unit);
  }

  @override
  Future<Unit> CacheMembewithRanks(MemberModel members) {
    MemberStore.cacheMemberRank(members);
    return Future.value(unit);
  }

  @override
  Future<MemberModel?> GetMemberWithRanks() {
    final members = MemberStore.getCachedMemberRank();
    return members;
  }
}

