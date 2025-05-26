part of 'pv_bloc.dart';
enum PvStatus { initial, loading, loaded, error,Added,Deleted }
 class PvState extends Equatable {

  final List<PV> pvs;
  final String Message;
  final String link;
  final PvStatus status;
  const PvState({this.pvs = const [], this.Message = '', this.link = '', this.status = PvStatus.initial});
  PvState copyWith({
    List<PV>? pvs,
    String? Message,
    String? link,
    PvStatus? status,
  }) {
    return PvState(
      pvs: pvs ?? this.pvs,
      Message: Message ?? this.Message,
      link: link ?? this.link,
      status: status ?? this.status,
    );
  }
  @override
  List<Object> get props => [pvs, Message, link, status];
}

final class PvInitial extends PvState {
  @override
  List<Object> get props => [];
}
