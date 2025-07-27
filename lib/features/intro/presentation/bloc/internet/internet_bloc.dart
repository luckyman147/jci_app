import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  StreamSubscription? _subscription;

  InternetCubit() : super(InternetInitial());
  void Connected() {
    emit(ConnectedState("Connected"));
  }

  void NotConnected() {
    emit(NotConnectedState("Not Connected"));
  }

  void CheckConnection() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (
          result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)
      ) {
        Connected();
      } else {
        NotConnected();
      }
    });
  }


  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
