import 'dart:convert';



import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/presentation/widgets/MemberSelection.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/auth/data/models/Member/AuthModel.dart';



class MemberStore{
  const MemberStore._();
  static const String _CachedMembersKey= 'CachedMembers';

  static const String  _UserInfo = 'UserInfo';
  static String _memberID(String id)=> 'Member_$id';
  static Future<void> cacheMembers(List<MemberModel> Members) async{
    final pref = await SharedPreferences.getInstance();
    List MembersModelToJson=Members.map((e) => e.toJson()).toList();
    pref.setString(_CachedMembersKey, jsonEncode(MembersModelToJson));
  }


  static Future<List<MemberModel>> getCachedMembers() async{
    final pref = await SharedPreferences.getInstance();
    final cachedMembers=pref.getString(_CachedMembersKey);
    if(cachedMembers!=null){
      List<dynamic> MembersJson=jsonDecode(cachedMembers);
      return  MembersJson.map<MemberModel>((e) => MemberModel.fromJson(e)).toList();
    }
    return [];
  }
  static Future<void> clearCache() async{
    final pref = await SharedPreferences.getInstance();
    pref.remove(_CachedMembersKey);
  }

  static Future<void> saveModel(MemberModel auth) async {
    final prefs = await SecureSharedPref.getInstance();

    final value = auth.toJson();


    prefs.putString(_UserInfo, jsonEncode(value));
  }
  static Future<MemberModel?> getModel() async {
    final prefs = await SecureSharedPref.getInstance();

    final value = await  prefs.getString(_UserInfo);

    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }

    return MemberModel.fromJson(jsonDecode(value));
  }
  static Future<void> clearModel() async {
    final prefs = await SecureSharedPref.getInstance();

    prefs.putString(_UserInfo, '');
  }
  static Future<Unit> saveMemberBYID(MemberModel auth,String id) async {
    final prefs = await SecureSharedPref.getInstance();

    final value = auth.toJson();
    prefs.putString(_memberID(id), jsonEncode(value));
return Future.value(unit);

}
  static Future<MemberModel?> getMemberByID(String id) async {
    final prefs = await SecureSharedPref.getInstance();

    final value = await  prefs.getString(_memberID(id));

    if (value == null) {
      return null;
    }
    if (value.isEmpty) {
      return null;
    }

    return MemberModel.fromJson(jsonDecode(value));
  }

  static Future<void> clearMemberByID(String id) async {
    final prefs = await SecureSharedPref.getInstance();

    prefs.putString(_memberID(id), '');
  }
  static Future<void> clearAll() async {
    final prefs = await SecureSharedPref.getInstance();

    prefs.putString(_UserInfo, '');
    prefs.putString(_CachedMembersKey, '');
  }

}