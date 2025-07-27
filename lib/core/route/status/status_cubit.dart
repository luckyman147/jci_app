import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import '../../../features/Home/Activity_Global.dart';
import '../../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../config/services/store.dart';

part 'status_state.dart';

class StatusCubit extends Cubit<StatusState> {
  // Initialize with an appropriate initial state directly in the super call
  StatusCubit( this.store) : super(StatusInitial());


  final Store store;

  Future<void> checkAuthStatus() async {



    final language = await store.getLocaleLanguage();
    final isFirstEntry = await store.isFirstEntry();

    // Handle Either results
    final isLoggedIn = await store.isLoggedIn();

    Logger().w(isLoggedIn);
    Logger().w(language);
    Logger().w(isFirstEntry);



    try {
      if (language == null) {
        emit(state.copyWith(status: RouteStatus.Language));
      }  else if (isLoggedIn) {
        setAuthenticated();
      }else if (isFirstEntry) {
        setFirstEntry();
      } else if (!isLoggedIn) { // This condition covers the token expired scenario
setTokenExpired();      } else {
setError();      }
    } catch (e) {
setError();    }
  }

  // Manual state setters
  void setAuthenticated() => emit(StatusState(status: RouteStatus.Authenticated));
  void setFirstEntry() => emit(StatusState(status: RouteStatus.IsFirstEntry));
  void setTokenExpired() => emit(StatusState(status: RouteStatus.TokenExpired));
  void setAnonym() => emit(StatusState(status: RouteStatus.IsAnonym));
  void setError() => emit(StatusState(status: RouteStatus.Error));
  void reset() => emit(StatusInitial());
}