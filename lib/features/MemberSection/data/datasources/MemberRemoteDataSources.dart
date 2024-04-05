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
import '../../../auth/data/models/Member/AuthModel.dart';

import'package:http/http.dart' as http;
abstract class MemberRemote {
  Future<MemberModel> getUserProfile();
  Future<List<MemberModel>> GetmMemberByName(
      String name
      );
  Future<List<MemberModel>> GetMembers();
  Future<Unit> deleteAccount();

Future<Unit> UpdateMember(MemberModel memberModel);



}
class MemberRemoteImpl implements MemberRemote {
  final http.Client client;

  MemberRemoteImpl({required this.client});

  @override
  Future<MemberModel> getUserProfile() async {

    final tokens=await getTokens();


    // replace with your API endpoint
    final  AccessToken =  tokens[1]; // replace with your actual access token
    print("Access token");
    print(AccessToken);
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
        print("response ${response}");
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
    final  AccessToken =  tokens[1]; // replace with your actual access token
    try {
      final Response = await client.get(
        Uri.parse(getallMembers),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $AccessToken',
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
  Future<Unit> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }

  @override
  Future<Unit> UpdateMember(MemberModel memberModel)async  {
    final tokens= await Store.GetTokens();
    final body =memberModel.toJson();
    debugPrint(body.toString()  );

    return client.patch(
      Uri.parse(getUserProfileUrl),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${tokens[1]}"

      },
      body: json.encode(body),
    ).then((response) async {
      log(response.statusCode.toString());
      if (response.statusCode == 200) {



        final upload_response=await UpdateImage(memberModel.id, memberModel.Images[0],getUserProfileUrl+"/");
        if (upload_response.statusCode==200){
          MemberStore.saveModel(memberModel);
          return  Future.value(unit);
        }
        else if (upload_response.statusCode==400){
          debugPrint(upload_response.reasonPhrase.toString());

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




}