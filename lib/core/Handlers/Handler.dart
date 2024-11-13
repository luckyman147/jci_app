import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/IHandler.dart';
import 'package:jci_app/core/error/Failure.dart';
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
        logger.e(e); // Log the error

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
}
