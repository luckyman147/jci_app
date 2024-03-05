import 'package:dartz/dartz.dart';
import 'package:jci_app/features/auth/data/models/Member/AuthModel.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../../core/config/services/MemberStore.dart';
import '../../../../core/error/Exception.dart';

abstract class MembersLocalDataSource {
  Future<List<MemberModel>> getAllCachedmembers();
  Future<Unit> cacheMembers(List<MemberModel> members);



}

class MembersLocalDataSourceImpl implements MembersLocalDataSource{
  @override
  Future<Unit> cacheMembers(List<MemberModel> event)async {
    await MemberStore.cacheMembers(event);
    return Future.value(unit);
  }




  @override
  Future<List<MemberModel>> getAllCachedmembers() async {
    final Members=await MemberStore.getCachedMembers();
    if (Members.isNotEmpty) {
      return Members;
    } else {
      throw EmptyCacheException();
    }
  }




}