import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/MemberSection/presentation/functions/functionMember.dart';

part 'member_permission_event.dart';
part 'member_permission_state.dart';

class MemberPermissionBloc
    extends Bloc<MemberPermissionEvent, MemberPermissionState> {
  MemberPermissionBloc(this.functionMember) : super(MemberPermissionInitial()) {
    on<MemberPermissionEvent>((event, emit) async {
      // TODO: implement event handler
    });

    on<checkIsowner>(checkIsOwner);
  }
  final FunctionMember functionMember;

  void CheckIsAdminAndNoOwner(CheckIsSuperAdminNoOwner event,
      Emitter<MemberPermissionState> emit) async {
    final isOwner = await functionMember.isOwner(event.memberID);
    emit(state.copyWith(isadmin: false, isowner: isOwner));
  }

  void checkIsOwner(
      checkIsowner event, Emitter<MemberPermissionState> emit) async {
    emit(state.copyWith(isLoading: true));
    final isOwner = await functionMember.isOwner(event.memberID);
    emit(state.copyWith(isowner: isOwner, isLoading: false));
  }
}
