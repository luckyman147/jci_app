part of 'objectif_bloc.dart';
enum ObjectifStatus{initial, Loading,Success,Failure,Created,FailureCreation,CreationLoading,Deleted,Updated}
enum ObjectiveEvent{Delete,Create,Edit,NoAction}
 class ObjectifState extends Equatable {
  const ObjectifState({
    this.status = ObjectifStatus.initial,
    this.objectifs = const [],
    this.objectifsHome = const [],
    this.hasReachedMax = false,
    this.lastDocument,
    this.event = ObjectiveEvent.NoAction,
    this.groupBYObjectifs = const {},


 });
final Map<String,List<UserObjectifInfos>> groupBYObjectifs;
  final ObjectifStatus status;
  final ObjectiveEvent event;
  final List<UserObjectifInfos> objectifs;
  final List<UserObjectifInfos> objectifsHome;

  final bool hasReachedMax;
  final DocumentSnapshot? lastDocument;

ObjectifState copyWith({
    List<UserObjectifInfos>? objectifsHome,

  Map<String,List<UserObjectifInfos>>? groupBYObjectifs,
    List<UserObjectifInfos>?objectifs,

    ObjectifStatus? status,
    bool? hasReachedMax,
    ObjectiveEvent? event,
  DocumentSnapshot? lastDocument

 }){
    return ObjectifState(

      objectifsHome: objectifsHome??this.objectifsHome,
      event: event??this.event,
      groupBYObjectifs: groupBYObjectifs??this.groupBYObjectifs,
      lastDocument: lastDocument??this.lastDocument,
      objectifs: objectifs??this.objectifs,
      status: status??this.status,
      hasReachedMax: hasReachedMax??this.hasReachedMax,
    );
  }

    @override
    List<Object> get props => [
      event,

      objectifsHome,
      status,
      objectifs,
      hasReachedMax,
      groupBYObjectifs,];


}

final class ObjectifInitial extends ObjectifState {
  @override
  List<Object> get props => [];
}
