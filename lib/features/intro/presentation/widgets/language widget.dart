import '../widgets.global.dart';

class Language_widget extends StatefulWidget {
  const Language_widget({Key? key}) : super(key: key);

  @override
  State<Language_widget> createState() => _Language_widgetState();
}

class _Language_widgetState extends State<Language_widget> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), ),


      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButton<String>(
        value: "English",
        items: const [],
        onChanged: (Object? value) {},
        icon: Image.asset(
          "assets/icons/18165.jpg",
          fit: BoxFit.fitHeight,
          height: 24,
          width: 39,
        ),
      ),
    ),]));
  }
}
