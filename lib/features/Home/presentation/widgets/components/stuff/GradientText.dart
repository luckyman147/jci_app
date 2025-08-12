import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText({
    super.key,
    required this.text,
    required this.style,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: AutoSizeText(
        text,
        style: style.copyWith(color: Colors.white), // color will be ignored due to shader
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
