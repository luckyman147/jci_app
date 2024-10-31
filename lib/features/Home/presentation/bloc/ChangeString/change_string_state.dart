part of 'change_string_bloc.dart';

@immutable
abstract class ChangeStringState extends Equatable{
  final String value;

  const ChangeStringState(this.value);

}

class ChangeStringInitial extends ChangeStringState {
  ChangeStringInitial(super.value);

  @override
  // TODO: implement props
  List<Object?> get props => [value];
}



class StringLoaded extends ChangeStringState {
  StringLoaded(super.value);

  @override
  // TODO: implement props
  List<Object?> get props => [value];




}
class ResetState extends ChangeStringState {

  ResetState(super.value);
  @override
  List<Object> get props => [value];
}
