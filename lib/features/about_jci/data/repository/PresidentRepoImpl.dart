import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/about_jci/Domain/Repository/PresidentsRepo.dart';
import 'package:jci_app/features/about_jci/Domain/entities/President.dart';

import '../../../../core/error/Exception.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/LocalPresidentsDataSources.dart';
import '../datasources/RemotePresidentsDataSources.dart';
import '../models/PresidentModel.dart';

class PresidentRepoImpl implements PresidentsRepo  {
  final LocalPresidentsDataSources localPresidentsDataSources;
  final RemotePresidentsDataSources remotePresidentsDataSources;

final Handler<President> Preshandler;
final Handler<Unit> Unithandler;
final Handler<(List<PresidentModel>, DocumentSnapshot?)> Combohandler;


  PresidentRepoImpl({required this.localPresidentsDataSources,
    required this.Preshandler,
    required this.Unithandler,
    required this.Combohandler,
    required this.remotePresidentsDataSources, });
  @override
  Future<Either<Failure, President>> CreatePresident(President president) async{
    await localPresidentsDataSources.CacheUpdated(true);

    return await _getMessagePresident(remotePresidentsDataSources.createPresident(PresidentModel.fromEntity(president)));
  }

  @override
  Future<Either<Failure, Unit>> DeletePresident(String id) async{
    await localPresidentsDataSources.CacheUpdated(true);

    return await _getMessage(remotePresidentsDataSources.deletePresident(id));

  }

  @override
  Future<Either<Failure, President>> UpdateImagePresident(President president) async{
    final presidentmodel= PresidentModel.fromEntity(president);
    await localPresidentsDataSources.CacheUpdated(true);

    return await _getMessagePresident(remotePresidentsDataSources.updateImagePresident(presidentmodel.id,president.CoverImage));

  }

  @override
  Future<Either<Failure, President>> UpdatePresident(President president)async  {
    final presidentmodel= PresidentModel.fromEntity(president);
    await localPresidentsDataSources.CacheUpdated(true);

    return await _getMessagePresident(remotePresidentsDataSources.updatePresident(presidentmodel));

  }

  @override
  Future<Either<Failure, (List<President>, DocumentSnapshot?)>> getPresidents(    int limit, {
    DocumentSnapshot? lastDocument,
  }) async{
    // just make the remote please

   return await Combohandler.handle(onCall: (){
      return remotePresidentsDataSources.getPresidents(limit, lastDocument: lastDocument);
    }, onError: (e)=> Failure.fromException(e)
    );
  }

  Future<Either<Failure, Unit>> _getMessage(
      Future<Unit> presidents) async {
    return Unithandler.handle  (onCall: (){
      return presidents;
    }
    ,    onError: (e)=> Failure.fromException(e)
    );
}
  Future<Either<Failure, President>> _getMessagePresident(
      Future<PresidentModel> presidents) async {
    return Preshandler.handle  (onCall: (){
      return presidents;
    },
    onError: (e)=> Failure.fromException(e)


    );
  }

}
