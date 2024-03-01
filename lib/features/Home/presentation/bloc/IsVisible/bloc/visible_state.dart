part of 'visible_bloc.dart';


final class VisibleInitial extends VisibleState {
  VisibleInitial(super.isVisible, super.isPaid);
}

final class EndDateVisible extends VisibleState {
  EndDateVisible(super.isVisible, super.isPaid);
}

final class IsPaid extends VisibleState {
  IsPaid(super.isVisible, super.isPaid);
}
class VisibleState extends Equatable {
  final bool isVisible;
  final bool isPaid;

  VisibleState(this.isVisible, this.isPaid);

  VisibleState copyWith({
    bool? isVisible,
    bool? isPaid,
  }) {
    return VisibleState(
      isVisible ?? this.isVisible,
      isPaid ?? this.isPaid,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isVisible,isPaid];
}
