import '../error/Failure.dart';

const String SERVER_FAILURE_MESSAGE = 'Please try again later .';
const String EMPTY_CACHE_FAILURE_MESSAGE = 'No Data';
const String OFFLINE_FAILURE_MESSAGE = 'Please Check your Internet Connection';
const String SIGNUP_FAILURE_MESSAGE="Sign up failed Please try again";
 String mapFailureToMessage(Failure failure) {
switch (failure.runtimeType) {
case ServerFailure:
return SERVER_FAILURE_MESSAGE;
case OfflineFailure:
return OFFLINE_FAILURE_MESSAGE;
default:
return "Unexpected Error , Please try again later .";
}
}