import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../core/networks/network_info_test.dart';



final sl = GetIt.instance;

void setupTestDependencies() {
  sl.reset(); // Clear previous registrations if any

  // Create the mock instance
  final mockNetworkInfo = MockNetworkInfo();
sl.registerFactory(() => Logger());
  // Register mocks and dependencies
  sl.registerFactory(() => Handler<Unit>(sl(), networkInfo: mockNetworkInfo));
  sl.registerFactory(() => Handler<dynamic>(sl(), networkInfo: mockNetworkInfo));
  sl.registerFactory(() => Handler<bool>(sl(), networkInfo: mockNetworkInfo));
}
