



import 'dart:core';

import 'package:dartz/dartz.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';

import '../error/Failure.dart';

abstract class IHandler<T,Error>{

  Future<Either<Failure,T>> handle
  ({
    required Future<T> Function() onCall,

    required  Error Function(dynamic param) onError,
  });
  Stream<Either<Failure,T>> handleSTream
  ({
    required Stream<T> Function() onCall,

    required  Error Function(dynamic param) onError,
  });


  Future<Either<Failure,T>> handleActivity
  ({
    required Future<T> Function() onCallEvents,
    required Future<T> Function() onCallMeetings,
    required Future<T> Function() onCallTrainings,
    required Future<T> Function() onCallAll,

    required  Error Function(dynamic param) onError,
    required activity param
  });

}


