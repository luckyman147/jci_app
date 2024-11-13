import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'bloc_observer.dart';


import 'firebase_options.dart';
import 'injection_container.dart' as di;
import 'package:firebase_app_check/firebase_app_check.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`


    androidProvider: AndroidProvider.debug,


  );
  // Get the App Check token



  final pref= await SharedPreferences.getInstance();
  final secure=await SecureSharedPref.getInstance();


  Bloc.observer = AppObserver();

  runApp(const MyApp());
}

