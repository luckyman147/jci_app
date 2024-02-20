part of 'change_string_bloc.dart';



abstract class ChangeStringEvent extends Equatable {

}
class SetStringEvent extends ChangeStringEvent {
  final String value;

  SetStringEvent({required this.value});

  @override
  List<Object> get props => [value];
}

class resetString extends ChangeStringEvent{
  @override
  // TODO: implement props
  List<Object?> get props => []
  ;
}
