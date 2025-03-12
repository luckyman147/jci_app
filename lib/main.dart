import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jci_app/core/config/services/FCMService/FCmServi.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'bloc_observer.dart';

import 'core/config/services/NotificationService/NotificationService.dart';
import 'features/auth/AuthWidgetGlobal.dart';
import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'package:firebase_app_check/firebase_app_check.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  NotificationService.initialize(); // Initialize notification service
  await dotenv.load(fileName: ".env");
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  getFcmToken(messaging);
  messaging.onTokenRefresh.listen((newToken) {
    storeFcmToken( newToken);  // Store the refreshed token in Firestore
  });

  await FirebaseAppCheck.instance.activate(



    androidProvider: AndroidProvider.debug,


  );

  // Get the App Check token



  final pref= await SharedPreferences.getInstance();
  final secure=await SecureSharedPref.getInstance();


  Bloc.observer = AppObserver();

  runApp(const MyApp());
}


