import '../../../../../Home/Activity_Global.dart';

class AnimatedCheckAvatar extends StatefulWidget {
  const AnimatedCheckAvatar({super.key});

  @override
  State<AnimatedCheckAvatar> createState() => _AnimatedCheckAvatarState();
}

class _AnimatedCheckAvatarState extends State<AnimatedCheckAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        builder: (context, borderWidth, child) {
          return Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.green,
                width: borderWidth,
              ),
            ),
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white,
              child: Icon(Icons.check, color: Colors.green, size: 20),
            ),
          );
        },
      ),
    );
  }
}
