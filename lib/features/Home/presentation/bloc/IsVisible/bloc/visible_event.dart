part of 'visible_bloc.dart';

sealed class VisibleEvent extends Equatable {
  const VisibleEvent();

  @override
  List<Object> get props => [];
}

final class VisibleEndDateToggleEvent extends VisibleEvent {
  final bool isvisible;
  VisibleEndDateToggleEvent(this.isvisible);
}

final class VisibleIsPaidToggleEvent extends VisibleEvent {
  final bool ispaid;
  VisibleIsPaidToggleEvent(this.ispaid);
}

final class ResetEvent extends VisibleEvent {
  ResetEvent();
}
