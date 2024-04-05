import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'member_management_event.dart';
part 'member_management_state.dart';

class MemberManagementBloc extends Bloc<MemberManagementEvent, MemberManagementState> {
  MemberManagementBloc() : super(MemberManagementInitial()) {
    on<MemberManagementEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
