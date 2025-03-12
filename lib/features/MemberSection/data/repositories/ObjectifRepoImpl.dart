import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/MemberSection/data/datasources/ObjectidDataSource.dart';
import 'package:jci_app/features/MemberSection/data/model/ObjectifsModels.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/MemberSection/domain/entity/UserObjectifInfos.dart';
import 'package:jci_app/features/MemberSection/domain/repositories/objectifsRepo.dart';

class ObjectifRepoImpl implements ObjectifRepo{
  final Handler<Unit> handler;
  final Handler<({List<UserObjectifInfos> userObjectifInfos, DocumentSnapshot? lastDoc})> objectifHandler;
final ObjectifDataSource objectifDataSource;
  ObjectifRepoImpl(this.objectifDataSource, this.objectifHandler, {required this.handler});
  @override
  Future<Either<Failure, Unit>> AddObjectif(Objectif objectif)async {
return await handler.handle(onCall: (){
   return objectifDataSource.AddObjectif(ObjectifModel.fromEntity(objectif));

 }, onError: (e){
   if (e is Exception){
     throw e;
   }

 });
  }

  @override
  Future<Either<Failure, Unit>> DeleteObjectif(String objectifId)async {
    return await handler.handle(onCall: (){
      return objectifDataSource.deleteObjectif(objectifId);

    }, onError: (e){
      if (e is Exception){
        throw e;
      }

    });
  }

  @override
  Future<Either<Failure, Unit>> UpdateObjectif(Objectif objectif)async {
    return await handler.handle(onCall: (){
    return objectifDataSource.UpdateObjectif(ObjectifModel.fromEntity(objectif));

  }, onError: (e){
    if (e is Exception){
      throw e;
    }

  });
  }

  @override
  Future<Either<Failure, ({List<UserObjectifInfos> userObjectifInfos, DocumentSnapshot? lastDoc})>> fetchUserWithHisObjectifsProgress({required String userId, DocumentSnapshot<Object?>? lastDocument, required int limit}) async{
    return await objectifHandler.handle(onCall: (){
      return  objectifDataSource.fetchUserWithHisObjectifsProgress(userId: userId, lastDocument: lastDocument, limit: limit);
    }, onError: (e){
      if (e is Exception){
        throw e;
      }
    });
  }
}