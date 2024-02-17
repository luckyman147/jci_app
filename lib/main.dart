import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_shared_preferences/secure_shared_pref.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'bloc_observer.dart';


import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  final pref= await SharedPreferences.getInstance();
  final secure=await SecureSharedPref.getInstance();


  Bloc.observer = AppObserver();

  runApp(MyApp());
}

