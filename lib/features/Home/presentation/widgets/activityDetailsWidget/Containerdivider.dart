import '../../../Activity_Global.dart';

Container NoImageCard(Color color,double height) {
  return Container(
    height: height,
    width: double.infinity, // Ensure the container spans the full width
    decoration:  BoxDecoration(
      color: color, // Add transparency to make layers visible
    ),
  );
}