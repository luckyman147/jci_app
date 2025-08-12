
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

import 'core/di/Services/app_initialize.dart';
import 'features/auth/AuthWidgetGlobal.dart';

import 'injection_container.dart' as di;


void main() async {

  await di.init();
  await  di.sll<AppInitializer>().init();


   // Logs widget build times

  runApp(const MyApp());
}
