import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/usescases/usecase.dart';
import '../../../domain/usecases/authusecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RefreshTokenUseCase refreshTokenUseCase;

  AuthBloc({required this.refreshTokenUseCase}) : super(AuthInitial()){
    on<RefreshTokenEvent>(
_onRefreshToken,
    );}
  Future<void> _onRefreshToken(
      RefreshTokenEvent event,
      Emitter<AuthState> emit,
      ) async {
    if (event is RefreshTokenEvent) {
      emit(AuthLoading());
      final result = await refreshTokenUseCase.call(NoParams());
      emit(_eitherDoneMessageOrErrorState(
          result, 'Token Refreshed Successfully'));

    
  }}

  AuthState _eitherDoneMessageOrErrorState(
      Either<Failure, bool> either, String message) {
    return either.fold(
          (failure) => AuthFailureState(
        message: mapFailureToMessage(failure),
      ),
          (_) => AuthSuccessState(),
    );
  }
}

