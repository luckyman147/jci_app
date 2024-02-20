import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:jci_app/features/Home/Activity_Injection_container.dart';

import 'package:jci_app/features/auth/auth%20_injection_container.dart';

import 'package:http/http.dart' as http;



final sl = GetIt.instance;

Future<void> init() async {
initActivities();
initAuth();
}
