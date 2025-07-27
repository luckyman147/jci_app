import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:jci_app/core/mixins/Loggable.dart';

class AppCheckService with Loggable {
  Future<void> activate() async {
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
      );
      log.i('[AppCheckService] App Check activated.');
    } catch (e) {
      log.e('[AppCheckService] Error activating App Check: $e');
      rethrow;
    }
  }
}
