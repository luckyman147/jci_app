import 'package:dartz/dartz.dart';

import '../error/Failure.dart';


const String SERVER_FAILURE_MESSAGE = 'Please try again later .';
const String EMPTY_CACHE_FAILURE_MESSAGE = 'Cache failure';
const String OFFLINE_FAILURE_MESSAGE = 'Please Check your Internet Connection';
const String SIGNUP_FAILURE_MESSAGE = "Sign up failed Please try again";
const String EMAIL_EXISTED_FAILURE_MESSAGE = "Email already existed";
const String WRONG_CRED_Failure = "Wrong credentials Check Again";
String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case OfflineFailure:
      return OFFLINE_FAILURE_MESSAGE;
    case EmptyCacheFailure:
      return EMPTY_CACHE_FAILURE_MESSAGE;
    case EmailExistedFailure:
      return EMAIL_EXISTED_FAILURE_MESSAGE;
    case WrongCredentialsFailure:
      return WRONG_CRED_Failure;

    default:
      return "Unexpected Error , Please try again later .";
  }
}
