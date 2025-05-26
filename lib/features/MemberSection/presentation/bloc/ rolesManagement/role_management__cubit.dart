import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';

part 'role_management__state.dart';


class RoleManagementCubit extends Cubit<CibleType?> {
  RoleManagementCubit() : super(null); // Initial state is null

  // Update the CibleType value
  void update(CibleType? newValue) => emit(newValue);

  // Clear the current value (set to null)
  void clear() => emit(null);

  // Toggle between null and a specific value
  void toggle(CibleType value) => emit(state == value ? null : value);
}