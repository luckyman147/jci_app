import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/IHandler.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:logger/logger.dart';
import '../network/network_info.dart';



class Handler<T> implements IHandler<T, Failure> {
  final NetworkInfo networkInfo;
  final Logger logger ;

  Handler(this.logger, {required this.networkInfo});

  @override
  Future<Either<Failure, T>> handle({
    required Future<T> Function() onCall,
    required dynamic Function(dynamic error) onError,
    Future<T> Function()? onFailConnection
    // Change Exception to dynamic
  }) async {
    if (await networkInfo.isConnected) {
      try {
        T result = await onCall(); // Await the result from onCall
        return Right(result); // Return the successful result
      } catch (e) {
        logger.e(e);

        return Left(onError(e)); // Pass the caught error to onError
      }
    } else {
      if (onFailConnection != null) {
        T result = await onFailConnection(); // Await the result from onFailConnection
        return Right(result); // Return the successful result
      }
      return Left(OfflineFailure()); // Return OfflineFailure if no network
    }
  }

  @override
  Future<Either<Failure, T>> handleActivity({
    required Future<T> Function() onCallEvents,
    required Future<T> Function() onCallMeetings,
    required Future<T> Function() onCallTrainings
    , required Future<T> Function() onCallAll,
    required Failure Function(dynamic param) onError,
     Future<T> Function()? onFailConnection,

  required activity param
  })async {
    if (await networkInfo.isConnected) {
      try {
        switch (param) {
          case activity.Events:
            T result = await onCallEvents();
            return Right(result);
          case activity.Meetings:
            T result = await onCallMeetings();
            return Right(result);
          case activity.Trainings:
            T result = await onCallTrainings();
            return Right(result);
          case activity.All:
            T result = await onCallAll();
            return Right(result);

        }
      } catch (e) {
        logger.e(e);
        return Left(onError(e));
      }
    } else {

      if (onFailConnection != null) {



        T result = await onFailConnection(); // Await the result from onFailConnection
        return Right(result); // Return the successful result
      }
      return Left(OfflineFailure()); // Return OfflineFailure if no network
    }



  }

  @override
  Stream<Either<Failure, T>> handleSTream({required Stream<T> Function() onCall, required Failure Function(dynamic param) onError}) async*{
    if (await networkInfo.isConnected) {
      try {
        await for (T result in onCall()) {
          yield Right(result);
        }
      } catch (e) {
        logger.e(e);
        yield Left(onError(e));
      }
    } else {
      yield Left(OfflineFailure());
    }
  }
}
