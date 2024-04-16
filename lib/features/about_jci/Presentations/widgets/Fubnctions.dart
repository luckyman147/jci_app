import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';

class JCIFunctions{
  static double getHeight(String text, double fontSize, double width) {
    final TextPainter textPainter = TextPainter(
      maxLines: null,
      text: TextSpan(
        text: text,
        style: PoppinsRegular(fontSize, textColorBlack, ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);

    return textPainter.height;
  }

}