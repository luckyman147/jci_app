import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/seeder/membersSeeder.dart';
import 'package:jci_app/core/config/services/FCMService/FCmServi.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'bloc_observer.dart';

import 'core/BuildingBlocks-Permissions/Permissions/Data/seeder/RoleSeeder.dart';
import 'core/config/services/NotificationService/NotificationService.dart';
import 'features/auth/AuthWidgetGlobal.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  GestureBinding.instance.samplingOffset = const Duration(milliseconds: 16);
  GestureBinding.instance?.resamplingEnabled = true;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugProfileBuildsEnabled = true; // Logs widget build times
  final st = di.sl<FSMToken>();
  NotificationService.initialize(); // Initialize notification service
  await dotenv.load(fileName: ".env");
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  st.getFcmToken(messaging);
  //await MemberSeeder.seedMembersOneByOne();
  //await RoleSeeder(FirebaseFirestore.instance).seedRoles(count: 1);
  messaging.onTokenRefresh.listen((newToken) {
    st.storeFcmToken(newToken); // Store the refreshed token in Firestore
  });

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  // Get the App Check token

  final pref = await SharedPreferences.getInstance();
  debugPrintRebuildDirtyWidgets = true; // Logs unnecessary rebuilds
  Bloc.observer = AppObserver();

  runApp(const MyApp());
}
