import 'package:flutter/material.dart';

import '../../../../Home/Activity_Global.dart';

// Reusable IconButton widget for different actions
class ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color PrimaryColor ;

  const ActionButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.PrimaryColor =textColorBlack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon,color: PrimaryColor),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}

// Reusable MenuItem widget for different actions
class MenuItem extends PopupMenuEntry {
final IconData icon;
final String title;
final VoidCallback onTap;

const MenuItem({
required this.icon,
required this.title,
required this.onTap,
super.key,
});

@override
double get height => 56.0;

@override
bool represents(dynamic value) => false;

@override
State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
@override
Widget build(BuildContext context) {
return PopupMenuItem(
child: ListTile(
leading: Icon(widget.icon),
title: Text(widget.title),
onTap: () {widget.onTap();
Navigator.pop(context); // Close the popup before action

},
),
);
}
}


class MyTaskButtons extends StatelessWidget {
  const MyTaskButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return

      BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Search Button
                ActionButton(
                  icon: Icons.search,
                  onPressed: () {
                    context.read<TaskVisibleBloc>().add(ChangeWillSearchEvent(!state.willSearch));

                  },
                  tooltip: "Search",
                ),

                // Column Button

      
              Container(
                  decoration: BoxDecoration(
                    color: PrimaryColor,
                    //shape 
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:   Row(children: [
  // Arrow Back with Popup Menu
  ActionButton(
    PrimaryColor: ColorsApp.textColorWhite,
    icon: Icons.add,
    onPressed: () {
      // Open a PopupMenuButton when the arrow button is pressed
      _showPopupMenu(context, mediaQuery);
    },
    tooltip: "Back",
  ),])),
                
                // Plus Button
              ],
            ),
          );});
    
        }
      
  

  void _showPopupMenu(BuildContext context, MediaQueryData mediaQuery) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        mediaQuery.size.width - 100, // Right of the screen
        100.0, // Top of the screen
        0.0, // Left of the screen
        0.0, // Bottom of the screen
      ),
      items: <PopupMenuEntry>[
        MenuItem(
          icon: Icons.task_alt,
          title: "Create Task",
          onTap: () {
            print("Settings clicked");
            Navigator.pop(context); // Close the menu
          },
        ),
        MenuItem(
          icon: Icons.app_registration_sharp,
          title: "Create Strategy",
          onTap: () {

            Navigator.pop(context); // Close the menu
          },
        ),
      ],
    );
  }
}
