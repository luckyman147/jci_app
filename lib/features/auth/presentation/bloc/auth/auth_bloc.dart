import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/config/services/store.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/usescases/usecase.dart';

import '../../../domain/entities/Member.dart';
import '../../../domain/usecases/authusecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RefreshTokenUseCase refreshTokenUseCase;
  final SignOutUseCase signoutUseCase;


  AuthBloc({required this.refreshTokenUseCase,required this.signoutUseCase,




  }) : super(AuthInitial()){
    on<RefreshTokenEvent>(
_onRefreshToken,

    );

    on<SignoutEvent>(_onSignoutEvent);

  }




  Future <void> _onSignoutEvent(
      SignoutEvent event,
      Emitter<AuthState> emit,
      ) async {

final statu=await Store.getStatus();
      final result = await signoutUseCase.call(statu);
      emit(_eitherDoneMessageOrErrorState(
          result, 'Signout Successfully'));


  }








  Future<void> _onRefreshToken(
      RefreshTokenEvent event,
      Emitter<AuthState> emit,
      ) async {


      final result = await refreshTokenUseCase.call(NoParams());
      emit(_eitherDoneRefreshedOrErrorState(
          result, 'Token Refreshed Successfully'));

    
  }

  AuthState _eitherDoneMessageOrErrorState(
      Either<Failure, bool> either, String message) {
    return either.fold(
          (failure) => AuthFailureState(
        message: mapFailureToMessage(failure),
      ),
          (vakue) {
            if (vakue){
         return   AuthSuccessState();
          }
          return AuthFailureState(message: 'Signout Failed');
          }
    );
  }  AuthState _eitherDoneRefreshedOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
          (failure) => AuthFailureState(
        message: mapFailureToMessage(failure),
      ),
          (_) => AuthSuccessState(),
    );
  }



}

