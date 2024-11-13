import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc() : super(PermissionsLoadingState()) {
    on<PermissionsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
