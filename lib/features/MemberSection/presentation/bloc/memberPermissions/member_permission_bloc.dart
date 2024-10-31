
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';


part 'member_permission_event.dart';
part 'member_permission_state.dart';

class MemberPermissionBloc extends Bloc<MemberPermissionEvent, MemberPermissionState> {
  MemberPermissionBloc() : super(MemberPermissionInitial()) {
    on<MemberPermissionEvent>((event, emit) async {
      // TODO: implement event handler
    });
    on<checkIsAdmin>(CheckIsAdmin);
    on<checkIsSuper>(CheckIsSuper);
    on<checkIsowner>(checkIsOwner);

  }

  void CheckIsAdminAndNoOwner(CheckIsSuperAdminNoOwner event,
      Emitter<MemberPermissionState>emit) async {
    final isAdmin = await FunctionMember.isSuper();
    final isOwner = await FunctionMember.isOwner(event.memberID);
    emit(state.copyWith(isadmin: isAdmin,isowner: isOwner));
  }

  void checkIsOwner(checkIsowner event,
      Emitter<MemberPermissionState>emit) async {
    final isOwner = await FunctionMember.isOwner(event.memberID);
    emit(state.copyWith(isowner: isOwner));
  }

  void CheckIsAdmin(checkIsAdmin event,
      Emitter<MemberPermissionState>emit) async {
    final isAdmin = await FunctionMember.isAdmin();
    emit(state.copyWith(isadmin: isAdmin,));
  }
  void CheckIsSuper(checkIsSuper event,
      Emitter<MemberPermissionState>emit) async {
    final isSuper = await FunctionMember.isSuper();
    emit(state.copyWith(isSuperAdmin: isSuper,));
  }
}