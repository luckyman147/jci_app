part of 'description_bool_bloc.dart';

abstract class DescriptionBoolState extends Equatable {
  final bool isFullDescription; const DescriptionBoolState(this.isFullDescription);
}

class DescriptionBoolInitial extends DescriptionBoolState {
  DescriptionBoolInitial(super.isFullDescription);

  @override
  List<Object> get props => [];
}


class DescriptionToggleState extends DescriptionBoolState {
  DescriptionToggleState(super.isFullDescription);





  @override
  // TODO: implement props
  List<Object?> get props => [isFullDescription];
}
