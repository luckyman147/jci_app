part of 'objectif_bloc.dart';
enum ObjectifStatus{initial, Loading,Success,Failure,Created,FailureCreation,CreationLoading}
 class ObjectifState extends Equatable {
  const ObjectifState({
    this.status = ObjectifStatus.initial,
    this.objectifs = const [],
    this.hasReachedMax = false,
    this.lastDocument

 });

  final ObjectifStatus status;
  final List<UserObjectifInfos> objectifs;
  final bool hasReachedMax;
  final DocumentSnapshot? lastDocument;

ObjectifState copyWith({
    List<UserObjectifInfos>?objectifs,
    ObjectifStatus? status,
    bool? hasReachedMax,
  DocumentSnapshot? lastDocument

 }){
    return ObjectifState(
      lastDocument: lastDocument??this.lastDocument,
      objectifs: objectifs??this.objectifs,
      status: status??this.status,
      hasReachedMax: hasReachedMax??this.hasReachedMax,
    );
  }

    @override
    List<Object> get props => [status,objectifs,hasReachedMax];


}

final class ObjectifInitial extends ObjectifState {
  @override
  List<Object> get props => [];
}
