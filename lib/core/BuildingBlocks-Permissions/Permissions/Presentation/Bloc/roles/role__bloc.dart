import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Dtos/RolePermissionsDto.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/UseCases/RoleUsesCases.dart';
import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../../features/intro/presentation/widgets.global.dart';
import '../../../../../error/Failure.dart';
import '../../../domain/Entities/Role.dart';

part 'role__event.dart';
part 'role__state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final CreateRoleUsesCase createRoleUsesCase;
  final UpdateRoleInfoUseCase updateRoleInfoUseCase;
  final UpdateRolePermissionsUseCase updateRolePermissionsUseCase;
  final ChangeRoleOfUserUseCase changeRoleOfUserUseCase;
  final FetchRolesUseCase fetchRolesUseCase;
  final FetchRoleByNameUseCase fetchRoleByNameUseCase;
  RoleBloc(this.createRoleUsesCase, this.updateRoleInfoUseCase, this.updateRolePermissionsUseCase, this.changeRoleOfUserUseCase, this.fetchRolesUseCase, this.fetchRoleByNameUseCase) : super(RoleInitial()) {
    on<RoleEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<CreateRoleEvent>(_onCreated);
    on<UpdateRoleInfosEvent>(_onUpdateRoleInfos);
    on<UpdateRolePermissionsEvent>(_onUpdateRolesPermissions);
    on<ChangeRoleOfUserEvent>(_OnUserRoleChanged);
    on<FetchRolesEvent>(_fetchRoles);
    on<FetchRoleByNameEvent>(_fetchRoleByName);
  }
  Future<void> _onCreated(
      CreateRoleEvent event, Emitter<RoleState> emit) async {
    emit(state.copyWith(status: RoleApiStatus.Loading));
    try {
      final result = await createRoleUsesCase(event.role);
      emit(_eitherSuccessOrFailure(
        result,
            (role) => state.copyWith(
          status: RoleApiStatus.Created,

        ),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RoleApiStatus.Error,
      ));
    }
  }
  Future<void> _onUpdateRoleInfos(
      UpdateRoleInfosEvent event, Emitter<RoleState> emit) async {
    emit(state.copyWith(status: RoleApiStatus.Loading));
    try {
      final result = await updateRoleInfoUseCase(event.role, );
      emit(_eitherSuccessOrFailure(
        result,
            (updatedRole) => state.copyWith(
          status: RoleApiStatus.Updated,),
      ));
    } catch (e) {
      emit(state.copyWith(status: RoleApiStatus.Error));
    }
  }
  Future<void> _onUpdateRolesPermissions(
      UpdateRolePermissionsEvent event, Emitter<RoleState> emit) async {
    emit(state.copyWith(status: RoleApiStatus.Loading));
    try {
      final result = await updateRolePermissionsUseCase(
          event.rolePermissionsDto);
      emit(_eitherSuccessOrFailure(
        result,
            (updatedRole) => state.copyWith(
          status: RoleApiStatus.Loaded,

        ),
      ));
    } catch (e) {
      emit(state.copyWith(status: RoleApiStatus.Error));
    }
  }

  Future<void> _OnUserRoleChanged(
      ChangeRoleOfUserEvent event, Emitter<RoleState> emit) async {
    emit(state.copyWith(status: RoleApiStatus.Loading));
    try {
      final result = await changeRoleOfUserUseCase(event.changeRoleParams);
      emit(_eitherSuccessOrFailure(
        result,
            (success) => state.copyWith(status: RoleApiStatus.Changed),
      ));
    } catch (e) {
      emit(state.copyWith(status: RoleApiStatus.Error));
    }
  }

  Future<void> _fetchRoles(FetchRolesEvent event, Emitter<RoleState> emit) async {
    emit(state.copyWith(status: RoleApiStatus.Loading));
    try {
      final result = await fetchRolesUseCase(NoParams());
      emit(_eitherSuccessOrFailure(
        result,
            (roles) => state.copyWith(
          status: RoleApiStatus.Loaded,
          roles: roles,
        ),
      ));
    } catch (e) {
      Logger().wtf(e.toString());
      emit(state.copyWith(status: RoleApiStatus.Error));
    }
  }

  Future<void> _fetchRoleByName(
      FetchRoleByNameEvent event, Emitter<RoleState> emit) async {
    emit(state.copyWith(status: RoleApiStatus.Loading));
    try {
      final result = await fetchRoleByNameUseCase(event.roleId);
      emit(_eitherSuccessOrFailure(
        result,
            (role) => state.copyWith(
          status: RoleApiStatus.Loaded,
          role: role, // Or handle differently if you want to keep all roles
        ),
      ));
    } catch (e) {
      emit(state.copyWith(status: RoleApiStatus.Error));
    }
  }


  RoleState _eitherSuccessOrFailure<T> (Either<Failure,T> request,Function(T) onSuccess){
  return   request.fold((failure) {
    if (failure is AlreadyExistedFailure){
    return  state.copyWith(message: "Role ${mapFailureToMessage(failure)}",status: RoleApiStatus.Error);
    }else{
      return state.copyWith(message: mapFailureToMessage(failure),status: RoleApiStatus.Error);

    }

  }, (response){
      return onSuccess(response);

    });
  }



}
