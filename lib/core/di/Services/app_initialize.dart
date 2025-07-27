import 'package:flutter/foundation.dart';
import 'package:jci_app/core/mixins/Loggable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc_observer.dart';
import '../../../features/Home/Activity_Global.dart';
import '../../config/services/NotificationService/NotificationService.dart';
import 'FCMServive.dart';
import 'Firebase_Service.dart';
import 'app_check_service.dart';

class AppInitializer with Loggable {
  final FirebaseService _firebaseService;

  final FCMService _fcmService;
  final AppCheckService _appCheckService;

  AppInitializer(
      this._firebaseService,

      this._fcmService,
      this._appCheckService,
      );

  Future<void> init() async {
    try {
      log.i('[AppInitializer] Starting app initialization...');
      debugProfileBuildsEnabled = true;
      await _firebaseService.initialize();


      NotificationService.initialize();

      await _fcmService.initialize();
      await _appCheckService.activate();
      // Get the App Check token
      // debugPrintRebuildDirtyWidgets = true; // Logs unnecessary rebuilds
      Bloc.observer = AppObserver();
      log.i('[AppInitializer] App fully initialized.');
    } catch (e) {
      log.e('[AppInitializer] Initialization failed: $e');
      rethrow;
    }
  }
}
