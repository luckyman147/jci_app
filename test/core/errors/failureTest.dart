import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/strings/failures.dart';


void main() {
  group('mapFailureToMessage', ()
  {
    test('returns the correct message for ServerFailure', () {
      final failure = ServerFailure();
      expect(mapFailureToMessage(failure), SERVER_FAILURE_MESSAGE);
    });

    test('returns the correct message for OfflineFailure', () {
      final failure = OfflineFailure();
      expect(mapFailureToMessage(failure), OFFLINE_FAILURE_MESSAGE);
    });

    test('returns the correct message for EmptyCacheFailure', () {
      final failure = EmptyCacheFailure();
      expect(mapFailureToMessage(failure), EMPTY_CACHE_FAILURE_MESSAGE);
    });

    test('returns the correct message for EmailExistedFailure', () {
      final failure = EmailExistedFailure();
      expect(mapFailureToMessage(failure), EMAIL_EXISTED_FAILURE_MESSAGE);
    });

    test('returns the correct message for WrongCredentialsFailure', () {
      final failure = WrongCredentialsFailure();
      expect(mapFailureToMessage(failure), WRONG_CRED_Failure);
    });

    test('returns the correct message for ExpiredFailure', () {
      final failure = ExpiredFailure();
      expect(mapFailureToMessage(failure), TOKEN_EXPIRED_FAILURE_MESSAGE);
    });

    test('returns the correct message for AlreadyLogoutFailure', () {
      final failure = AlreadyLogoutFailure();
      expect(mapFailureToMessage(failure), ALREA_FAILURE_MESSAGE);
    });

    test('returns the correct message for UnauthorizedFailure', () {
      final failure = UnauthorizedFailure();
      expect(mapFailureToMessage(failure), UNAUTHORIZED_MESSAGE);
    });

    test('returns the correct message for EmptyDataFailure', () {
      final failure = EmptyDataFailure();
      expect(mapFailureToMessage(failure), EMPTY_DATA_FAILURE_MESSAGE);
    });

    test('returns the correct message for AlreadyParticipatedFailure', () {
      final failure = AlreadyParticipatedFailure();
      expect(mapFailureToMessage(failure), AlreadyParticipated);
    });
  });}