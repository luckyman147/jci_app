part of 'visible_bloc.dart';


final class VisibleInitial extends VisibleState {

}

final class EndDateVisible extends VisibleState {

}

final class IsPaid extends VisibleState {

}
class VisibleState extends Equatable {
  final bool isVisible;
  final bool isPaid;
  final bool IsOnline;
  final bool isPrivate;

  const VisibleState({this.isVisible=false, this.isPaid=false, this.IsOnline=false, this.isPrivate=false});

  VisibleState copyWith({
    bool? isVisible,
    bool? isPaid,
    bool? IsOnline,
    bool? isPrivate,

  }) {
    return VisibleState(
    isVisible:   isVisible ?? this.isVisible,
   isPaid:    isPaid ?? this.isPaid,
      IsOnline: IsOnline?? this.IsOnline,
      isPrivate: isPrivate??this.isPrivate
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isVisible,isPaid,isPrivate,IsOnline];
}
