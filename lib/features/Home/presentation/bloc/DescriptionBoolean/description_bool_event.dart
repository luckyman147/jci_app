part of 'description_bool_bloc.dart';

abstract class DescriptionBoolEvent extends Equatable {
  const DescriptionBoolEvent();
  @override
  List<Object> get props => [];
}

class ShowFullDescriptionEvent extends DescriptionBoolEvent {}
