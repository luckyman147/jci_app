



import 'dart:core';

import 'package:dartz/dartz.dart';

import '../error/Failure.dart';

abstract class IHandler<T,Error>{

  Future<Either<Failure,T>> handle
  ({
    required Future<T> Function() onCall,

    required  Error Function(dynamic param) onError,
  });

}


