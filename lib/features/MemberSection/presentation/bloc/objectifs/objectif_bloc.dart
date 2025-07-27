import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/MemberSection/domain/entity/UserObjectifInfos.dart';
import 'package:jci_app/features/MemberSection/presentation/functions/FunctionObjectif.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../auth/AuthWidgetGlobal.dart';
import '../../../domain/dto/ObjectifPagination.dart';
import '../../../domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../../domain/usecases/ObjectifUsesCase.dart';

part 'objectif_event.dart';
part 'objectif_state.dart';
const throttleDuration = Duration(milliseconds: 600);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ObjectifBloc extends Bloc<ObjectifEvent, ObjectifState> {
  final fetchUserWithHisObjectifsProgressUsesCase fetch;
  final AddObjectifUsesCase addObjectif;

  final DeleteObjectifUsesCase deleteObjectif;
final UpdateObjectifUsesCase updateObjectif;
  ObjectifBloc(this.fetch, this.addObjectif, this.deleteObjectif, this.updateObjectif, ) : super(ObjectifInitial()) {
    on<ObjectifEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ChangeStatus>(( event,emit)=>emit(state.copyWith(status: event.status)));

    on<LoadObjectifs>(_loadObjectifs, transformer: throttleDroppable(throttleDuration));
    on<LoadMoreObjectifs>(_loadMoreObjectifs, transformer: throttleDroppable(throttleDuration));
  on<CreateObjectifEvent>(_CreateObjetifs);

  on<GroupByEvent>(_GroupByEvent);
  on<DeleteObjectifEvent>(_deleteObjectif);
  on<EditObjectifEvent>(_updateObjectif);
  on<SetEvent>((event, emit) {
    emit(state.copyWith(event: event.event));});

  }

















  ///Create Objectif event
  ///
  ///
  ///

  _CreateObjetifs(CreateObjectifEvent event,Emitter<ObjectifState>emit) async {

    try {
      emit(state.copyWith(status: ObjectifStatus.CreationLoading));
   final request=    await addObjectif.call(event.objectif);
      emit(EitherObjectifsOrSucces(request, (r) {

  return      state.copyWith(status: ObjectifStatus.Created);
      }));
    } catch (e) {
      Logger().e(e);
      emit(state.copyWith(status: ObjectifStatus.FailureCreation));
    }}
///Edit objetif
  _updateObjectif(EditObjectifEvent event,Emitter <ObjectifState>emit) async {
    emit(state.copyWith(status: ObjectifStatus.CreationLoading,event: ObjectiveEvent.Edit));

    try {
      final request = await updateObjectif.call(event.objectif);
      emit(EitherObjectifsOrSucces(request, (r) {
        //update the objectif from the list
        state.objectifs.removeWhere((element) => element.objectif.id == event.objectif.id);

        return state.copyWith(status: ObjectifStatus.Updated,event: ObjectiveEvent.NoAction,objectifs: state.objectifs);
      }));
    } catch (e) {
      Logger().e(e);
      emit(state.copyWith(status: ObjectifStatus.FailureCreation));
    }
  }

///Delete Objectif
_deleteObjectif(DeleteObjectifEvent event,Emitter<ObjectifState>emit) async {
  emit(state.copyWith(status: ObjectifStatus.CreationLoading,event: ObjectiveEvent.Delete));

  try {
    final request = await deleteObjectif.call(event.objectifId);
    emit(EitherObjectifsOrSucces<Unit>(request, (r) {
      //delete the objectif from the list
      state.objectifs.removeWhere((element) => element.objectif.id == event.objectifId);
      //update map
      if (state.groupBYObjectifs.isNotEmpty) {
        state.groupBYObjectifs.forEach((key, value) {
        value.removeWhere((element) => element.objectif.id == event.objectifId);
      });
      }
      return state.copyWith(status: ObjectifStatus.Deleted,event: ObjectiveEvent.NoAction,objectifs: state.objectifs,groupBYObjectifs: state.groupBYObjectifs);
    }));
  } catch (e) {
    Logger().e(e);
    emit(state.copyWith(status: ObjectifStatus.Failure));
  }
}

  ///group by objectifs
  _GroupByEvent(GroupByEvent event, Emitter<ObjectifState> emit) async {
    emit(state.copyWith(status: ObjectifStatus.Loading));

    Map<String,List<UserObjectifInfos>> groupByObjectifs =event.groupBy!=null? ObjectifFunctions.groupBy(state.objectifs, event.groupBy!):{};

    emit(state.copyWith(groupBYObjectifs: groupByObjectifs, status: ObjectifStatus.Success));
  }




  ///Load Objectifs event

   _loadObjectifs(LoadObjectifs event,Emitter<ObjectifState>emit) async {
    emit( state.copyWith(status: ObjectifStatus.Loading));
if (state.objectifs.isNotEmpty&&!event.isRefreshed){

  emit(state.copyWith(status: ObjectifStatus.Success));
}
if (event.isRefreshed){
  emit(state.copyWith(hasReachedMax: false));
}
    try {
      final objectifs = await fetch(
          ObjectifPaginationDto(
            userId: event.userId,
            lastDocument: null,

          )

      );
emit(EitherObjectifsOrSucces(objectifs,(objs) {
  if (objs.userObjectifInfos.isEmpty) {
    return state.copyWith(hasReachedMax: true);
  }

  else {
  return state.copyWith(
          objectifs: objs.userObjectifInfos,
          status: ObjectifStatus.Success,
    lastDocument: objs.lastDoc

        );}
} ));
    } catch (e) {
      Logger().w(e);
      emit( state.copyWith(status: ObjectifStatus.Failure));
    }
  }

  void _loadMoreObjectifs(LoadMoreObjectifs event,Emitter<ObjectifState>emit) async {
    if (state.hasReachedMax || state.status == ObjectifStatus.Loading) return;

    try {
      final objectifs = await fetch.call(
          ObjectifPaginationDto(
            userId: event.userId,
            lastDocument: event.lastDocument,

          )
      );



     emit( EitherObjectifsOrSucces<({List<UserObjectifInfos> userObjectifInfos, DocumentSnapshot? lastDoc})>(objectifs, (objs){

       if (objs.userObjectifInfos.isEmpty) {
         return state.copyWith(hasReachedMax: true);
       }

else {
         return  state.copyWith(
        objectifs: [...state.objectifs, ...objs.userObjectifInfos],
        status: ObjectifStatus.Success,
           lastDocument:objs.lastDoc
      );
       }


      }));
    } catch (_) {
      emit( state.copyWith(status: ObjectifStatus.Failure));
    }
  }
  ObjectifState EitherObjectifsOrSucces<T>(Either<Failure,T> request,Function(T) function){
    return request.fold(
      (l) => state.copyWith(status: ObjectifStatus.Failure),
      (r) => function(r),
    );
  }

}
