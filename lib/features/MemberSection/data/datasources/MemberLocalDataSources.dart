import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/presentation/widgets/MemberSelection.dart';

import '../../../../core/config/services/MemberStore.dart';
import '../../../../core/config/services/store.dart';
import '../../../auth/data/models/Member/AuthModel.dart';

abstract class MemberLocalDatasoources{
  Future<MemberModel?> getUserProfile();

  Future<Unit> ChangeUserProfile(MemberModel member);
  Future<List<MemberModel>> GetmMemberByName(
      String name
      );
  Future<List<MemberModel>> GetMembers();

  Future<Unit> CacheMembers(List<MemberModel> members);




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
}

