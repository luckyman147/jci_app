import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jci_app/features/auth/auth%20_injection_container.dart';
import 'package:jci_app/features/auth/data/datasources/LoginRemote.dart';
import 'package:jci_app/features/auth/data/datasources/signUpRemote.dart';
import 'package:jci_app/features/auth/data/repositories/LoginRepoImpl.dart';
import 'package:jci_app/features/auth/data/repositories/signUpRepoImpl.dart';
import 'package:jci_app/features/auth/domain/repositories/LoginRepo.dart';
import 'package:jci_app/features/auth/domain/repositories/SignUpRepo.dart';

import 'package:jci_app/features/auth/domain/usecases/SIgnIn.dart';
import 'package:jci_app/features/auth/domain/usecases/SignUp.dart';
import 'package:jci_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/sign_up_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';


final sl = GetIt.instance;

Future<void> init() async {

initAuth();
}
