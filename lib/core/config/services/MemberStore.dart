import 'dart:convert';



import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/auth/data/models/Member/AuthModel.dart';



class MemberStore{
  const MemberStore._();
  static const String _CachedMembersKey= 'CachedMembers';

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

}