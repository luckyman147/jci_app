import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/strings/failures.dart';

import '../../../../../MemberSection/presentation/widgets/functionMember.dart';
import '../../../../Domain/entities/BoardYear.dart';
import '../../../../Domain/useCases/BoardUseCases.dart';
import 'package:jci_app/core/error/Failure.dart';


part 'boord_event.dart';
part 'boord_state.dart';

class BoordBloc extends Bloc<BoordEvent, BoordState> {
  final GetBoardByYearUseCase getBoardByYearUseCase;
  final AddBoardUseCase addBoardUseCase;
  final RemoveBoardUseCase removeBoardUseCase;
  final RemoveMemberBoardUseCase removeMemberBoardUseCase;
  final AddMemberBoardUseCase addMemberBoardUseCase;

  BoordBloc(this.getBoardByYearUseCase, this.addBoardUseCase, this.removeBoardUseCase, this.removeMemberBoardUseCase, this.addMemberBoardUseCase) : super(BoordInitial()) {
    on<BoordEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchBoardYearsEvent>(onFetchBoardYearsEvent);
    on<AddBoardEvent>(onAddBoardEvent);
    on<RemoveBoardEvent>(_onremoveBoard);
    on<AddMemberEvent>(_onAddMemberBoard);
    on<RemoveMemberEvent>(_onRemoveMemberBoard);
  }


  void _onRemoveMemberBoard(RemoveMemberEvent event,Emitter<BoordState>emit)async {
    try{
      final result = await removeMemberBoardUseCase.call(event.postField);
    _mapRemoveMemberBoardOrFailure(result, emit);
    } catch (e) {
      emit(BoordState(state: BoardStatus.Error, message: e.toString()));
    }
  }
  void _onAddMemberBoard(AddMemberEvent event,Emitter<BoordState>emit)async {
    try{
      final result = await addMemberBoardUseCase.call(event.postField);
      _mapAddMemberBoardOrFailure(result, emit);
    } catch (e) {
      emit(BoordState(state: BoardStatus.Error, message: e.toString()));
    }
  }












  void _onremoveBoard (RemoveBoardEvent event,Emitter<BoordState>emit)async {
    try{
      final result = await removeBoardUseCase.call(event.year);
      _mapRemoveBoardOrFailure(result, emit,event.year);
    } catch (e) {
      emit(BoordState(state: BoardStatus.Error, message: e.toString()));
    }
  }
  void onFetchBoardYearsEvent(FetchBoardYearsEvent event,Emitter<BoordState>emit)async {
    try{
      emit(const BoordState(state: BoardStatus.Loading,));
      final result = await getBoardByYearUseCase.call(event.year);
     emit( await _mapGetBoardOrFailure(result, emit));

    } catch (e) {
      emit(BoordState(state: BoardStatus.Error, message: e.toString()));
    }

  }
  void onAddBoardEvent(AddBoardEvent event,Emitter<BoordState>emit)async {
    try{

      final result = await addBoardUseCase.call(event.year);
      _mapAddBoardOrFailure(result, emit);
      log("'messagesssssss'");
    } catch (e) {
      emit(BoordState(state: BoardStatus.Error, message: e.toString()));
    }

  }

 Future< BoordState> _mapGetBoardOrFailure(Either<Failure, BoardYear> result, Emitter<BoordState> emit)  {
  return  result.fold(
          (l) async{
   return  state.copyWith(  state: BoardStatus.Error, boardYears: [], message: mapFailureToMessage(l));
      },
          (r) async {
        List<int> list = [];
        if (await FunctionMember.isSuper()) {
          for (final element in r.posts) {
            int kol = element.length + 1;
            list.add(kol);
          }
        } else {
          for (final element in r.posts) {
            list.add(element.length);
          }
        }

return state.copyWith(boardYears: [r] ,state: BoardStatus.Loaded,Listlength: list);

      },
    );
  }

  void _mapAddBoardOrFailure(Either<Failure, Unit> result, Emitter<BoordState> emit,) {
    result.fold((l) {
      emit(BoordState(state: BoardStatus.Error, message: mapFailureToMessage(l)));
    }, (r) {
      log("'messagesssssss'");

      emit(BoordState(state: BoardStatus.Changed, message: 'Added', boardYears: state.boardYears));
    });
  }

  void _mapRemoveBoardOrFailure(Either<Failure, Unit> result, Emitter<BoordState> emit,String year) {
    result.fold((l) {
      emit(BoordState(state: BoardStatus.Error, message: mapFailureToMessage(l)));
    }, (r) {
final list=List.of(state.boardYears);
      list.removeWhere((element) => element.year==year);
      emit(BoordState(state: BoardStatus.Removed, message: 'Removed Successfully', boardYears: list));
    });
  }

  void _mapAddMemberBoardOrFailure(Either<Failure, Unit> result, Emitter<BoordState> emit) {
    result.fold((l) {
      emit(BoordState(state: BoardStatus.Error, message: mapFailureToMessage(l)));
    }, (r) {

      emit(BoordState(state: BoardStatus.Changed, message: ' Member Added', boardYears: state.boardYears));
    });
  }

  void _mapRemoveMemberBoardOrFailure(Either<Failure, Unit> result, Emitter<BoordState> emit) {

    result.fold((l) {
      emit(BoordState(state: BoardStatus.Error, message: mapFailureToMessage(l)));
    }, (r) {

      emit(BoordState(state: BoardStatus.Removed, message: ' Member Removed', boardYears: state.boardYears));
    });
  }
}
