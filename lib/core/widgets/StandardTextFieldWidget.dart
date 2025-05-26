
import '../../features/Home/Activity_Global.dart';

class StandardTextFieldWidget extends StatelessWidget {
  final BuildContext context;
  final String name;
  final String hintText;
  final TextEditingController controller;
  final Function(String) onChanged;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final bool autofocus;
  final TextInputAction textInputAction;
  final bool isMultiline;

  const StandardTextFieldWidget({
    Key? key,
    required this.context,
    required this.name,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.autofocus = true,
    this.textInputAction = TextInputAction.next,
    this.isMultiline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderFieldText(name: name),
          TextFormField(
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: keyboardType ?? (isMultiline ? TextInputType.multiline : TextInputType.text),
            textInputAction: textInputAction,
            autofocus: autofocus,
            autocorrect: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: onChanged,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text'.tr(context);
              }
              return null;
            },
            style: PoppinsNorml(18, textColorBlack),
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: border(PrimaryColor),
              enabledBorder: border(ThirdColor),
              errorBorder: border(Colors.red),
              focusedErrorBorder: border(PrimaryColor),
              errorStyle: ErrorStyle(15, Colors.red),
              hintStyle: PoppinsNorml(18, ThirdColor),
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderFieldText extends StatelessWidget {
  const HeaderFieldText({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: PoppinsRegular(18, textColorBlack),
    );
  }
}
