import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/app_theme.dart';

class ScrollingTextAnimation extends StatefulWidget {
  final String name;
  final String address;

  const ScrollingTextAnimation({
    Key? key,
    required this.name,
    required this.address,
  }) : super(key: key);

  @override
  State<ScrollingTextAnimation> createState() => _ScrollingTextAnimationState();
}

class _ScrollingTextAnimationState extends State<ScrollingTextAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Duration for full animation cycle
    );

    // Define the animation for moving left to right and right to left
    _animation = Tween<Offset>(
      begin: const Offset(.0, 0), // Start completely off-screen to the left
      end: const Offset(.06, 0), // End completely off-screen to the right
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Add reverse direction and start the animation

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: _animation.value * MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  widget.name,


                  style: PoppinBold(23.sp,
                      textColorBlack, TextDecoration.none),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
