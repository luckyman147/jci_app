part of 'checklist_bloc.dart';
enum ChecklistStatus { initial, loading, success, failure }

class ChecklistState {
  final ChecklistStatus status;
  final List<CheckList> checklists;
  final String? error;

  ChecklistState({
    this.status = ChecklistStatus.initial,
    this.checklists = const [],
    this.error,
  });

  ChecklistState copyWith({
    ChecklistStatus? status,
    List<CheckList>? checklists,
    String? error,
  }) {
    return ChecklistState(
      status: status ?? this.status,
      checklists: checklists ?? this.checklists,
      error: error,
    );
  }
}

final class ChecklistInitial extends ChecklistState {
  @override
  List<Object> get props => [];
}
