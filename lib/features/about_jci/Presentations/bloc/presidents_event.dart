part of 'presidents_bloc.dart';

abstract class PresidentsEvent extends Equatable {
  const PresidentsEvent();
}
class GetAllPresidentsEvent extends PresidentsEvent {
  @override
  List<Object> get props => [];
}
class CreatePresident extends PresidentsEvent {
  final President president;
  CreatePresident(this.president);
  @override
  List<Object> get props => [president];
}
class DeletePresident extends PresidentsEvent {
  final String id;
  DeletePresident(this.id);
  @override
  List<Object> get props => [id];
}
class UpdatePresident extends PresidentsEvent {
  final President president;
  UpdatePresident(this.president);
  @override
  List<Object> get props => [president];
}
class UpdateImagePresident extends PresidentsEvent {
  final President president;
  UpdateImagePresident(this.president);
  @override
  List<Object> get props => [president];
}

