import 'dart:convert';
import 'dart:developer';


import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';

import '../../../../core/config/env/urls.dart';
import '../../../../core/config/services/store.dart';
import '../../../../core/config/services/uploadImage.dart';
import '../../../../core/config/services/verification.dart';
import '../../../../core/error/Exception.dart';
import '../../../../core/MemberModel.dart';

import'package:http/http.dart' as http;
abstract class MemberRemote {
  Future<MemberModel> getUserProfile();
  Future<List<MemberModel>> GetmMemberByName(
      String name
      );

  Future<List<MemberModel>> GetMembers();
  Future<List<MemberModel>> getMembersWithRanks();
  Future<Unit> deleteAccount();
  Future<MemberModel> getMemberByid(String id);

Future<Unit> UpdateMember(MemberModel memberModel);

Future<Unit> UpdatePoints(String memberid, double cotisation);
Future<Unit> validateMember(String memberid);
Future<Unit> ChangeToAdmin(String memberid);
Future<Unit> ChangeToSuperAdmin(String memberid);
Future<Unit> ChangeToMember(String memberid);
Future<Unit> validateCotisation(String memberid,int type, bool cotisation);

  Future<Unit> ChangeLanguage(String language) ;

  Future<Unit> SendInactivityReport(String id) ;

  Future<Unit> SendMembershipReport(String id);

 Future<MemberModel> getMemberWithHightRank() ;

  Future<Unit> deleteMember(String id);

}
class MemberRemoteImpl implements MemberRemote {
  final http.Client client;

  MemberRemoteImpl({required this.client});

  @override
  Future<MemberModel> getUserProfile() async {

    final tokens=await getTokens();


    // replace with your API endpoint
    final  AccessToken =  tokens[1]; // replace with your actual access token

    try {
      final Response = await client.get(
        Uri.parse(getUserProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $AccessToken',
        },

      );
      print(" ya get ${Response.statusCode}");
      if (Response.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(Response.body);
        print("response $response");
        final  MemberModel member=MemberModel.fromJson(response);
        await  MemberStore.saveModel(member);




        return Future.value(member);
      }


      else {
        // Request failed
        print('Request failed with status: ${Response.statusCode}');
        print('Response body: ${Response.body}');
        throw ServerException();
      }
    } catch (e) {
      // Exception occurred during the request
      print('Exception during request: $e');
      throw ServerException();
    }


  }


  @override
  Future<List<MemberModel>> GetmMemberByName(String name)async  {

    final tokens=await getTokens();
    try {

      final Response = await client.get(
        Uri.parse("$getMember/name/$name"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${tokens[1]}',
        },

      );
      print(" ya get ${Response.statusCode}");
      if (Response.statusCode == 200) {
        final decodedJson = json.decode(Response.body) as List<dynamic>;
        final membermodels = decodedJson.map<MemberModel>((jsonMember) => MemberModel.fromJson(jsonMember)).toList();
        return membermodels;








      }
      else  if (Response.statusCode==401){
        throw UnauthorizedException();
      }
      else {
        // Request failed
        print('Request failed with status: ${Response.statusCode}');
        print('Response body: ${Response.body}');
        throw ServerException();
      }




    } catch (e) {
      // Exception occurred during the request
      print('Exception during request: $e');
      throw ServerException();
    }
  }

  @override
  Future<List<MemberModel>> GetMembers() async {

    final tokens=await getTokens();

    // replace with your API endpoint
    final  AccessToken =  tokens[1];

    try {
      final Response = await client.get(
        Uri.parse(getallMembers),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $AccessToken',
        },

      );

      if (Response.statusCode == 200) {
        final model=await MemberStore.getModel();
        final decodedJson = json.decode(Response.body) as List<dynamic>;
        final membermodels = decodedJson.map<MemberModel>((jsonMember) => MemberModel.fromJson(jsonMember)).toList();
        membermodels.removeWhere((element) => element.id==model!.id);
        return membermodels;








      }
      else  if (Response.statusCode==401){
        throw UnauthorizedException();
      }
      else {
        // Request failed
        print('Request failed with status: ${Response.statusCode}');
        print('Response body: ${Response.body}');
        throw ServerException();
      }




    } catch (e) {
      // Exception occurred during the request
      print('Exception during request: $e');
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<Unit> UpdateMember(MemberModel memberModel)async  {
    final tokens= await Store().GetTokens();
    final body =memberModel.toJson();


    return client.patch(
      Uri.parse(getUserProfileUrl),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${tokens[1]}"

      },
      body: json.encode(body),
    ).then((response) async {
      log(response.statusCode.toString());
      if (response.statusCode == 200) {



        final uploadResponse=await UpdateImage(memberModel.id!, memberModel.Images[0],"$getUserProfileUrl/");
        if (uploadResponse.statusCode==200){
          // upload from response
          uploadResponse.stream.transform(utf8.decoder).listen((value) {
            print(value);
          });
          final responseBodyBytes = await uploadResponse.stream.toBytes();

          // decode bytes to JSON string
          final jsonString = utf8.decode(responseBodyBytes);

          // parse JSON string to a JSON object
          final jsonObject = json.decode(jsonString);

          final member=MemberModel.fromJson(jsonObject);
          await MemberStore.saveModel(member);
          return  Future.value(unit);
        }
        else if (uploadResponse.statusCode==400){
          debugPrint(uploadResponse.reasonPhrase.toString());

          throw EmptyDataException();

        }else {
          throw ServerException();
        }

      }
      else if (response.statusCode == 400) {
        throw WrongCredentialsException();
      }
      else if  (response.statusCode == 401){
        throw UnauthorizedException();
      }

      else {
        throw ServerException();
      }
    });
  }

  @override
  Future<MemberModel> getMemberByid(String id)async  {
    final tokens=await getTokens();


  // replace with your API endpoint
  final  AccessToken =  tokens[1]; // replace with your actual access token

  try {
    final Response = await client.get(
      Uri.parse("$getMember/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $AccessToken',
      },

    );
    print(" ya get ${Response.statusCode}");
    if (Response.statusCode == 200) {
      final Map<String, dynamic> response = jsonDecode(Response.body);

      final  MemberModel member=MemberModel.fromJson(response);




      return Future.value(member);
    }


    else {
      // Request failed
      print('Request failed with status: ${Response.statusCode}');
      print('Response body: ${Response.body}');
      throw ServerException();
    }
  } catch (e) {
    // Exception occurred during the request
    print('Exception during request: $e');
    throw ServerException();
  }
  }

  @override
  Future<Unit> UpdatePoints(String memberid, double cotisation) async {
  return _mappatchrequest(PointsUrl(memberid), {
    "Points": cotisation,

  });
  }

  @override
  Future<Unit> validateMember(String memberid) async {
    return _mappatchrequest(validationUrl(memberid), {

    });
  }

  @override
  Future<Unit> validateCotisation(String memberid, int type, bool cotisation) {
  return _mappatchrequest(CotisationUrl(memberid), {
    "type":type,
    "action":cotisation
  });
  }

  Future<Unit>_mappatchrequest(String url,Object body )async {
    final tokens=await getTokens();

    final  AccessToken =  tokens[1]; // replace with your actual access token

    try {
      final Response = await client.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $AccessToken',
        },
body: json.encode(body)

      );

      if (Response.statusCode == 200 || Response.statusCode == 201) {
        return Future.value(unit);

      }

      else if (Response.statusCode==401){
        throw UnauthorizedException();
      }



      else {

        throw ServerException();
      }
    } catch (e) {

      throw ServerException();
    }
  }

  @override
  Future<Unit> ChangeToAdmin(String memberid) {
    return _mappatchrequest(ChangeToAdminUrl(memberid), {
    });
  }

  @override
  Future<Unit> ChangeToMember(String memberid) {
    return _mappatchrequest(ChangeToMemberUrl(memberid), {
    });
  }

  @override
  Future<Unit> ChangeToSuperAdmin(String memberid) {
    return _mappatchrequest(ChangeToSuperUrl(memberid), {
    });
  }

  @override
  Future<Unit> ChangeLanguage(String language) {
    return _mappatchrequest(ChangeLanguageUrl, {
      "language":language
    });
  }

  @override
  Future<Unit> SendInactivityReport(String id)async {
    final tokens=await getTokens();

    final  AccessToken =  tokens[1]; // replace with your actual access token

    try {
      final Response = await client.post(
          Uri.parse(Urls.mailIcativityReporturl(id)),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $AccessToken',
          },


      );

      if (Response.statusCode == 200 || Response.statusCode == 201) {
        return Future.value(unit);

      }

      else if (Response.statusCode==401){
        throw UnauthorizedException();
      }



      else {

        throw ServerException();
      }
    } catch (e) {

      throw ServerException();
    }
  }

  @override
  Future<Unit> SendMembershipReport(String id) async{
    final tokens=await getTokens();

    final  AccessToken =  tokens[1]; // replace with your actual access token

    try {
      final Response = await client.post(
        Uri.parse(Urls.mailMembershipReporturl(id)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $AccessToken',
        },


      );

      if (Response.statusCode == 200 || Response.statusCode == 201) {
        return Future.value(unit);

      }

      else if (Response.statusCode==401){
        throw UnauthorizedException();
      }



      else {

        throw ServerException();
      }
    } catch (e) {

      throw ServerException();
    }
  }

  @override
  Future<List<MemberModel>> getMembersWithRanks() async{
    final tokens=await getTokens();

    // replace with your API endpoint
    final  AccessToken =  tokens[1];

    try {
      final Response = await client.get(
        Uri.parse(Urls.getMembersWithRank),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $AccessToken',
        },

      );

      if (Response.statusCode == 200) {

        final decodedJson = json.decode(Response.body) as List<dynamic>;
        final membermodels = decodedJson.map<MemberModel>((jsonMember) => MemberModel.fromJson(jsonMember)).toList();
        return membermodels;
      }
      else  if (Response.statusCode==401){
        throw UnauthorizedException();
      }
      else {
        throw ServerException();
      }

    } catch (e) {

      throw ServerException();
    }
  }

  @override
  Future<MemberModel> getMemberWithHightRank()async  {
    final tokens=await getTokens();

    final  AccessToken =  tokens[1]; // replace with your actual access token

    try {
      final Response = await client.get(
        Uri.parse(Urls.getMemberWithHightRank),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $AccessToken',
        },

      );

      if (Response.statusCode == 200) {
        final Map<String, dynamic> response = jsonDecode(Response.body);

        final  MemberModel member=MemberModel.fromJson(response);

        return Future.value(member);
      }


      else {

        throw ServerException();
      }
    } catch (e) {

        throw ServerException();
    }

  }

  @override
  Future<Unit> deleteMember(String id) async{
    final tokens=await getTokens();

    final  AccessToken =  tokens[1]; // replace with your actual access token

    try {
      final Response = await client.delete(
        Uri.parse(Urls.deleteMemberUrl(id)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $AccessToken',
        },

      );

      if (Response.statusCode == 204) {
        return Future.value(unit);
      }
      else  if (Response.statusCode==401){
        throw UnauthorizedException();
      }
      else if (Response.statusCode==404){
        throw WrongCredentialsException();
      }
      else {
        throw ServerException();
      }

    } catch (e) {

      throw ServerException();
    }
  }

}