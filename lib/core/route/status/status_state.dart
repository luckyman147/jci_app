part of 'status_cubit.dart';
enum RouteStatus{ Authenticated, IsFirstEntry,TokenExpired,IsAnonym,Initial,Error,Language}

 class StatusState extends Equatable {
  const StatusState({
    this.status = RouteStatus.Initial,
  });
  final RouteStatus status ;

  StatusState copyWith({
    RouteStatus? status,
  }) {
    return StatusState(
      status: status ?? this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status];
}

final class StatusInitial extends StatusState {
  @override
  List<Object> get props => [];
}
