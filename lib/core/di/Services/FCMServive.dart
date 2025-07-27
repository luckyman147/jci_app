import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jci_app/core/mixins/Loggable.dart';

import '../../../injection_container.dart';
import '../../config/services/FCMService/FCmServi.dart';

class FCMService with Loggable {
  Future<void> initialize() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final st = sll<FSMToken>();

      st.getFcmToken(messaging);

      messaging.onTokenRefresh.listen((newToken) {
        st.storeFcmToken(newToken);
        log.i('[FCMService] Token refreshed and stored.');
      });

      log.w('[FCMService] FCM initialized.');
    } catch (e) {
      log.e('[FCMService] Error initializing FCM: $e');
      rethrow;
    }
  }
}
