import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Home/data/datasources/PVs/PVLocalDataSources.dart';
import 'package:jci_app/features/Home/data/datasources/PVs/PVRemoteDataSource.dart';
import 'package:jci_app/features/Home/data/model/PVModel.dart';
import 'package:jci_app/features/Home/domain/entities/PVEntity/PV.dart';
import 'package:jci_app/features/Home/domain/repsotories/PVRepo.dart';

class PvRepoImpl extends PVrepo{
  final PVremoteDataSource remoteDataSource;
  final PvLocalDataSources localDataSources;
  final Handler<Unit> unitHandler;
  final Handler<List<PV>> listPVHandler;

  PvRepoImpl({required this.remoteDataSource, required this.localDataSources, required this.unitHandler, required this.listPVHandler});
  @override
  Future<Either<Failure, Unit>> AddPV(PV pv, String activityId)async {
    return await unitHandler.handle(onCall: ()async{
      final NewLink=await remoteDataSource.UploadFileToStorage(pv.link);
      final NewPv=pv.fromLink(NewLink);
      final pvModel=PvModel.fromEntity(NewPv);
      await remoteDataSource.addPV(pvModel, activityId);
      return unit;

    }, onError: (e){

      if (e is Exception) {
        return e.get_failure;
      }
    });

  }

  @override
  Future<Either<Failure, Unit>> DeletePV(String pvId, String activityId) async{
    return await unitHandler.handle(onCall: ()async{
      await remoteDataSource.deletePV(pvId, activityId);
      return unit;
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
    });
  }

  @override
  Future<Either<Failure, List<PV>>> GetPVs(String activityId) async{
    return await listPVHandler.handle(onCall: ()async{
      final local=await localDataSources.getPVs(activityId);
      if (local.isNotEmpty) {
        return local;
      }
        final pvs=await remoteDataSource.getPVs(activityId);
                          return pvs;
      }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> downloadFile(PV pv) async{
    return await unitHandler.handle(onCall: ()async{
      await remoteDataSource.downloadAndOpenFile(pv.link, pv.title);
      return unit;
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
    });
  }
}