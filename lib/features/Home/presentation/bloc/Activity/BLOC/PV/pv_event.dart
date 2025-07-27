part of 'pv_bloc.dart';

sealed class PvEvent extends Equatable {
  const PvEvent();
}
class LoadLink extends PvEvent {
  final String path;
  const LoadLink(this.path);
  @override
  List<Object> get props => [path];
}
class GetPvList extends PvEvent {
  final String id;
  const GetPvList(this.id);
  @override
  List<Object> get props => [id];
}
class downloadPvEvent extends PvEvent {
  final PV pv;
  const downloadPvEvent(this.pv);
  @override
  List<Object> get props => [pv];

}
class AddPvEvent extends PvEvent {
  final PvParamDto params;
  const AddPvEvent({required this.params});
  @override
  List<Object> get props => [params];
}
class DeletePvEvent extends PvEvent {
  final PvParamDto params;

  const DeletePvEvent(this.params);
  @override
  List<Object> get props => [params];
}