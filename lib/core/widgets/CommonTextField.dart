import 'StandardTextFieldWidget.dart';
import '../../features/Home/Activity_Global.dart';

class TextfieldNormal extends StatelessWidget {

  final String name;
  final String hintText;
  final TextEditingController controller;
  final Function(String) onChanged;


  const TextfieldNormal({
    super.key,

    required this.name,
    required this.hintText,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StandardTextFieldWidget(
      context: context,
      name: name,
      hintText: hintText,
      controller: controller,
      onChanged: onChanged,
      minLines: 1,
      maxLines: 2,
      keyboardType: name == "Points" || name.contains("Year")
          ? TextInputType.number
          : TextInputType.text,
      textInputAction: TextInputAction.next,
    );
  }
}class TextfieldDescription extends StatelessWidget {
  final String name;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const TextfieldDescription({
    super.key,
    required this.name,
    required this.hintText,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StandardTextFieldWidget(
      context: context,
      name: name,
      hintText: hintText,
      controller: controller,
      onChanged: onChanged,
      isMultiline: true,
      minLines: 1,
      maxLines: 2,
      textInputAction: TextInputAction.done,
    );
  }
}