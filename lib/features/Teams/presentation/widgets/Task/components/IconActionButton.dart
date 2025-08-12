import '../../../../../Home/Activity_Global.dart';

class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.action,
    required this.icon,
    this.color = Colors.black,
    this.destinations = const [],
  });

  final VoidCallback action;
  final IconData icon;
  final Color color;
  final List<PopupMenuEntry> destinations;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) {
        if (destinations.isNotEmpty) {
          showMenu(
            color: ColorsApp.textColorWhite,
            context: context,
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              details.globalPosition.dx,
              details.globalPosition.dy,
            ),
            items: destinations,
          );
        }
      },
      child: IconButton(
        icon: Icon(icon,),
        color: color,
        onPressed: action,
      ),
    );
  }
}