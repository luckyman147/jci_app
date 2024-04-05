import 'package:flutter/material.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';

class LoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child:LoadingWidget(), // Your loading widget
      ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent user from dismissing the dialog
    builder: (BuildContext context) {
      return LoadingDialog();
    },
  );
}
