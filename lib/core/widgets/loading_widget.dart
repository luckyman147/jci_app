import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  final List<Color> _colors = [
    ColorsApp.PrimaryColor, ColorsApp.SecondaryColor,
    Colors.greenAccent
  ];

  int _currentColorIndex = 0;
  late StreamController<int> _colorStreamController;

  @override
  void initState() {
    super.initState();
    _colorStreamController = StreamController<int>.broadcast();
    _startColorChangeAnimation();
  }

  void _startColorChangeAnimation() {
    // Create a timer that switches colors every time the progress completes a cycle
    Timer.periodic(Duration(seconds: 1), (timer) {
      // Ensure the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          // Update the color index every time the circle completes a 360-degree rotation
          _currentColorIndex = (_currentColorIndex + 1) % _colors.length;
        });

        _colorStreamController.add(_currentColorIndex);
      } else {
        timer.cancel(); // Stop the timer when the widget is no longer mounted
      }
    });
  }

  @override
  void dispose() {
    _colorStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: StreamBuilder<int>(
            stream: _colorStreamController.stream,
            builder: (context, snapshot) {
              // If no color is selected, default to red
              final color = snapshot.hasData ? _colors[snapshot.data!] : PrimaryColor
              ;

              return CircularProgressIndicator(
                color: color,
                strokeWidth: 3,
              );
            },
          ),
        ),
      ),
    );
  }
}
