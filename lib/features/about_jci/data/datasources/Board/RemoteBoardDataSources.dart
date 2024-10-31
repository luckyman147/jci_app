
import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:jci_app/core/config/env/urls.dart';
import 'package:jci_app/core/error/Exception.dart';

import '../../../../../core/config/services/store.dart';
import '../../models/BoardRoleModel.dart';
import '../../models/BoardYearModel.dart';
abstract class RemoteBoardDataSources {
  Future<List<String>> getYears();
  Future<BoardYearModel> getBoardByYear(String year);
  Future<Unit> addBoard(String year);
  Future<Unit> AddRole(BoardRoleModel boardrole);
  Future<Unit> RemoveRole(String id);
  Future<Unit> RemoveBoard(String year);
  Future<List<BoardRoleModel>> getBoardRoles(int priority);
  Future<Unit> AddPositionInBoard(String year,String role);
  Future<Unit> AddMemberBoard(String id,String memberId);
  Future<Unit> RemoveMemberBoard(String id,String memberId);
  Future<Unit> RemovePost(String id,String year);


}
class RemoteBoardDataSourcesImpl implements RemoteBoardDataSources {
  final http.Client client;

  RemoteBoardDataSourcesImpl({required this.client});
  UnitFunction(Map<String,dynamic> body,String url,int responseSuccess) async {
    final tokens= await Store.GetTokens();


    return client.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json",
        "Authorization": "Bearer ${tokens[1]}"

      },
      body: json.encode(body),
    ).then((response) async {

      if (response.statusCode == responseSuccess) {
        return Future.value(unit);

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


Future<Unit>     deleteFunction(http.Client client, String url) async {
    try {
      final tokens= await Store.GetTokens();

      final response = await client.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${tokens[1]}"
        },
      );



      if (response.statusCode == 204) {
        return Future.value(unit);
      } else if (response.statusCode == 400) {
        throw ServerException();
      } else if (response.statusCode == 404) {
        throw WrongCredentialsException();
      } else {
        throw ServerException();
      }
    } finally {
      // Do not close the client here if it's shared across requests
      // client.close();
    }
  }
  @override
  Future<List<String>> getYears()async {
return client.get(Uri.parse(getYearsUrl)).then((response) {
    if (response.statusCode == 200) {
      final List<String> years = [];
      final List<dynamic> decodedJson = json.decode(response.body);
      for (var element in decodedJson) {
        years.add(element);
      }
      return years;
    } else {
      throw EmptyDataException();
    }
  }).catchError((error) => throw ServerException());


  }

  @override
  Future<BoardYearModel> getBoardByYear(String year) {
    return client.get(Uri.parse(getBoardByYearUrl(year))).then((response) {
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        log(response.body);
        List<BoardYearModel> boardYears = (jsonDecode(response.body) as List)
            .map((item) => BoardYearModel.fromJson(item))
            .toList();

        return  boardYears.first;
      } else {
        throw EmptyDataException();
      }
    }).catchError((error) {
      log(error.toString());
      throw ServerException();
    }

  );

  }

  @override
  Future<Unit> addBoard(String year) async{
    return await UnitFunction(  {
    "year": year,
    },addBoardUrl,201);
  }



  @override
  Future<Unit> RemoveBoard(String year) async{
    return await deleteFunction(client, removeBoardUrl(year));
  }



  @override
  Future<List<BoardRoleModel>> getBoardRoles(int priority) {
    return client.get(Uri.parse(getBoardRoleUrl(priority))).then((response) {
      if (response.statusCode == 200) {

List<BoardRoleModel> boardYears = (jsonDecode(response.body) as List)
    .map((item) => BoardRoleModel.fromJson(item))
    .toList();
        return boardYears;
      } else {
        throw EmptyDataException();
      }
    }).catchError((error) => throw ServerException());

  }

  @override
  Future<Unit> AddPositionInBoard( String year,String role)async {
    return await UnitFunction(  {
      "year": year,
      "role": role
    },addPosiUrl,201);
  }

  @override
  Future<Unit> AddMemberBoard(String id, String memberId)async {
return await UnitFunction({
  "assignTo": memberId,
}, AddMemberBoardUrl(id), 200);
  }

  @override
  Future<Unit> RemoveMemberBoard(String id, String memberId)async {
    return await UnitFunction({
      "assignTo": memberId,
    }, RemoveMemberBoardUrl(id), 204);

  }

  @override
  Future<Unit> RemovePost(String id, String year) async{
    return await deleteFunction(client, RemovePostUrl(id,year));
  }

  @override
  Future<Unit> AddRole(BoardRoleModel boardRoleModel) async{
    return await UnitFunction(boardRoleModel.toJson(), AddRoleBoardUrl, 201);
  }

  @override
  Future<Unit> RemoveRole(String id) {
    return deleteFunction(client, RemoveBoardRoleUrl(id));
  }




}

