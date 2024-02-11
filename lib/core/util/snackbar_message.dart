import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';

class SnackBarMessage {
 static  void showSuccessSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: PoppinsNorml(20, Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

 static  void showErrorSnackBar(
      {required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,          style: PoppinsNorml(20, Colors.white),

        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
