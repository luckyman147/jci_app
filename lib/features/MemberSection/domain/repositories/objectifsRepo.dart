import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';

import '../../../../core/error/Failure.dart';
import '../entity/UserObjectifInfos.dart';

abstract class ObjectifRepo{
  Future<Either<Failure,Unit>> AddObjectif(Objectif objectif);
  Future<Either<Failure,Unit>> DeleteObjectif(String objectifId);
  Future<Either<Failure,Unit>> UpdateObjectif(Objectif objectif);
  Future<Either<Failure,({List<UserObjectifInfos> userObjectifInfos, DocumentSnapshot? lastDoc})>> fetchUserWithHisObjectifsProgress({
    required String userId,
    DocumentSnapshot? lastDocument,
    required int limit,
  });

}