import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/config/services/store.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../../features/auth/presentation/bloc/auth/auth_bloc.dart';

bool isTokenExpired(String token) {
  try {
    Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
    print("decodedToken");
    if (decodedToken.containsKey('exp')) {
      // 'exp' claim is present in the token
      int expirationTimestamp = decodedToken['exp'];


      // Get the current timestamp
      int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Check if the token has expired
      return expirationTimestamp < currentTimestamp;
    } else {
      print('token expired');
      // If 'exp' claim is not present, consider the token as expired
      return true;
    }
  } catch (e) {
    // Handle decoding errors
    print('Error decoding token: $e');
    return true; // Consider the token as expired in case of errors
  }
}
void check(BuildContext context)async {
  final authBloc = BlocProvider.of<AuthBloc>(context);

  if (bool.fromEnvironment("dart.vm.product")) {
    authBloc.add(RefreshTokenEvent());
  }

  final authState = authBloc.state;
  final language = await Store.getLocaleLanguage();
  final token = await Store.GetTokens();

  if (language == null) {
    context.go('/screen');
  } else if (authState is AuthSuccessState && token != null) {
    context.go('/home');
  }
  else if (authState is AuthLogoutState || authState is AuthFailureState) {
    context.go('/login');
  }
  else  {

    context.go('/Intro');
  }
}