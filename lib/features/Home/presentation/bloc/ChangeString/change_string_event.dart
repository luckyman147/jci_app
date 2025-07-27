part of 'change_string_bloc.dart';



abstract class ChangeStringEvent extends Equatable {

}
class SetImageEvent extends ChangeStringEvent {
  final String image;

  SetImageEvent({required this.image});

  @override
  List<Object> get props => [image];
}
class initImageEvent extends ChangeStringEvent {
  final List<String> image;

  initImageEvent({required this.image});
  @override
  List<Object> get props => [image];
}


