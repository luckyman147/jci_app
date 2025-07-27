import 'package:firebase_core/firebase_core.dart';
import 'package:jci_app/core/mixins/Loggable.dart';
import 'package:jci_app/firebase_options.dart';

class FirebaseService with Loggable {
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      log.i('[FirebaseService] Firebase initialized.');
    } catch (e) {
      log.e('[FirebaseService] Error initializing Firebase: $e');
      rethrow;
    }
  }
}
