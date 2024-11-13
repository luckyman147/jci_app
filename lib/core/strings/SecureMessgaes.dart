
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class SecureMessages{
  String generateSecureOTP() {
    // Generate a random seed
    final random = Random.secure();

    // Generate a random number between 100000 and 999999
    int otp = 100000 + random.nextInt(900000);

    return otp.toString();
  }
}