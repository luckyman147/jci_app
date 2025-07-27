part of 'visible_bloc.dart';

sealed class VisibleEvent extends Equatable {
  const VisibleEvent();

  @override
  List<Object> get props => [];
}

final class VisibleEndDateToggleEvent extends VisibleEvent {
  final bool isvisible;
  const VisibleEndDateToggleEvent(this.isvisible);
}

final class VisibleIsPaidToggleEvent extends VisibleEvent {
  final bool ispaid;
  const VisibleIsPaidToggleEvent(this.ispaid);
}

final class ResetEvent extends VisibleEvent {
  const ResetEvent();
}
final class ChangePrivacy extends VisibleEvent{
  final bool isPrivate;
  const ChangePrivacy(this.isPrivate);
}
final class ChangeOnline extends VisibleEvent{
  final bool IsOnline;
  const ChangeOnline(this.IsOnline);
}