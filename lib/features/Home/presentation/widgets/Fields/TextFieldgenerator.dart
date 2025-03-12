import '../../../Activity_Global.dart';
import '../buttons/ButtonsComponent.dart';

class TextFieldGenerator extends StatefulWidget {
  final List<TextEditingController> text;

  const TextFieldGenerator({super.key, required this.text});

  @override
  _TextFieldGeneratorState createState() => _TextFieldGeneratorState();
}

class _TextFieldGeneratorState extends State<TextFieldGenerator> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextFieldBloc, TextFieldState>(
      builder: (context, state) {


        if (widget.text.isEmpty) {
          context.read<TextFieldBloc>().add(AddTwoTextFieldEvent());
        }

        return Column(
          children: [
            for (int index = 0; index < widget.text.length; index += 2)
              _buildTextFieldRow(context, index),
          ],
        );
      },
    );
  }

  // Helper method to build each text field row
  Widget _buildTextFieldRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
      child: Row(
        children: [
          _buildTextField(
            context: context,
            controller: widget.text[index],
            hintText: "Points N°${(index / 2 + 1).toInt()}",
            isFirstField: true,
            index: index,
          ),
          const SizedBox(width: 8),
          _buildTextField(
            context: context,
            controller: widget.text[index + 1],
            hintText: "Duration",
            isFirstField: false,
            index: index,
          ),
        ],
      ),
    );
  }

  // Helper method to build individual TextFormField
  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required bool isFirstField,
    required int index,
  }) {
    return Expanded(
      flex: isFirstField ? 2 : 1,
      child: TextFormField(
        maxLines: isFirstField ? 2 : 1,
        minLines: 1,
        style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none),
        keyboardType: isFirstField ? TextInputType.text : TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text'.tr(context);
          }
          return null;
        },
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: PrefixIconButton(
            onPressed: () {
              if (index == widget.text.length - 2) {
                context.read<TextFieldBloc>().add(AddTwoTextFieldEvent());
              } else {
                context.read<TextFieldBloc>().add(RemoveTextFieldEvent([index, index + 1]));
              }
            },
            iconData: index == widget.text.length - 2 ? Icons.add : Icons.remove,
          ),
          hintText: hintText,
          focusedBorder: border(PrimaryColor),
          enabledBorder: border(ThirdColor),
          focusedErrorBorder: border(Colors.red),
          errorBorder: border(Colors.red),
          errorStyle: ErrorStyle(18, Colors.red),
          hintStyle: PoppinsNorml(18, ThirdColor),
        ),
      ),
    );
  }
}
