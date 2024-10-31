import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';

class MessageDisplayWidget extends StatelessWidget {
  final String message;
  const MessageDisplayWidget({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: SingleChildScrollView(
        child: Text(
          message,
          style: PoppinsSemiBold(16, textColorBlack, TextDecoration.none),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
