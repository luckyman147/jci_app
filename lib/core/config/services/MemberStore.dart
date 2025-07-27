import 'dart:convert';



import 'package:dartz/dartz.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../MemberModel.dart';
import '../../PrimitiveUser/UserModel.dart';



class MemberStore{
  final EncryptedSharedPreferences storage;
  const MemberStore(this.storage);

  static const String _CachedMembersKey= 'CachedMembers';
static const String _cachedMembersRank = 'CachedMembersWIthRanks';
  static const String  _UserInfo = 'UserInfo';
  static const String  _UserPrimInfo = 'UserPrimInfo';
  static String _memberID(String id)=> 'Member_$id';
  static String memberRank= 'MemberRank';

  static Future<void> cacheMembers(List<UserModel> Members) async{
    final pref = await SharedPreferences.getInstance();
    List MembersModelToJson=Members.map((e) => e.toJson(true)).toList();
    pref.setString(_CachedMembersKey, jsonEncode(MembersModelToJson));
  }
  static Future<void> cacheMembersWithRanks(List<MemberModel> Members) async{
    final pref = await SharedPreferences.getInstance();
    List MembersModelToJson=Members.map((e) => e.toJson()).toList();
    pref.setString(_cachedMembersRank, jsonEncode(MembersModelToJson));
  }
  static Future<List<MemberModel>> getCachedMembersWithRanks() async{
    final pref = await SharedPreferences.getInstance();
    final cachedMembers=pref.getString(_cachedMembersRank);
    if(cachedMembers!=null){
      List<dynamic> MembersJson=jsonDecode(cachedMembers);
      return  MembersJson.map<MemberModel>((e) => MemberModel.fromJson(e)).toList();
    }
    return [];
  }
  //cadhe member rank
  static Future<void> cacheMemberRank(MemberModel Members) async{
    final pref = await SharedPreferences.getInstance();
    final MembersModelToJson=Members.toJson();
    pref.setString(memberRank, jsonEncode(MembersModelToJson));
  }
  static Future<MemberModel?> getCachedMemberRank() async{
    final pref = await SharedPreferences.getInstance();
    final cachedMembers=pref.getString(memberRank);
    if(cachedMembers!=null){
      return MemberModel.fromJson(jsonDecode(cachedMembers));
    }
    return null;
  }


  static Future<List<UserModel>> getCachedMembers() async{
    final pref = await SharedPreferences.getInstance();
    final cachedMembers=pref.getString(_CachedMembersKey);
    if(cachedMembers!=null){
      List<dynamic> MembersJson=jsonDecode(cachedMembers);
      return  MembersJson.map<UserModel>((e) => UserModel.fromJson(e,true)).toList();
    }
    return [];
  }
  static Future<void> clearCache() async{
    final pref = await SharedPreferences.getInstance();
    pref.remove(_CachedMembersKey);
  }

   Future<void> saveModel(MemberModel auth) async {

    final value = auth.toJson();


    storage.setString(_UserInfo, jsonEncode(value));
  }
   Future<void> savePrimitiveModel(UserModel auth) async {


    final value = auth.toJson(true);


    storage.setString(_UserPrimInfo, jsonEncode(value));
  }
   Future<UserModel> getPrimitiveModel()async{

    final value = storage.getString(_UserPrimInfo);

    if (value == null) {
      throw Exception('No user found');
    }
    if (value.isEmpty) {
      throw Exception('No user found');
    }

    return UserModel.fromJson(jsonDecode(value),true);
  }
   Future<MemberModel?> getModel() async {

    final value = await  storage.getString(_UserInfo);

    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }

    return MemberModel.fromJson(jsonDecode(value));
  }
   Future<void> clearModel() async {

    storage.setString(_UserInfo, '');
  }
   Future<Unit> saveMemberBYID(MemberModel auth,String id) async {

    final value = auth.toJson();
    storage.setString(_memberID(id), jsonEncode(value));
return Future.value(unit);

}
   Future<MemberModel?> getMemberByID(String id) async {

    final value = await  storage.getString(_memberID(id));

    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }

    return MemberModel.fromJson(jsonDecode(value));
  }

   Future<void> clearMemberByID(String id) async {

    storage.setString(_memberID(id), '');
  }
   Future<void> clearAll() async {

    storage.clear();
    //storage.putString(_CachedMembersKey, '');
  }

}