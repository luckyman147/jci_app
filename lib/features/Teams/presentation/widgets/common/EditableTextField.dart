import '../../../../Home/Activity_Global.dart';

class EditableTextField extends StatefulWidget {
  final String initialText;
  final void Function(String) onConfirm;
  final VoidCallback onCancel;
  final  Color focusedColor;
  final String hintText;
  final int minLines;
  final Function (String name) onChanged;

  const EditableTextField({
    super.key,
    this.minLines=1,
    required this.onChanged ,
    this.hintText = "Edit task name",
    this.focusedColor = ColorsApp.BackWidgetColor,
    required this.initialText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<EditableTextField> createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.initialText);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onConfirm(text);
      FocusScope.of(context).unfocus(); // dismiss keyboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onCancel, // tap outside cancels
      child: TextField(
        minLines: 1,
        maxLines: widget.minLines,
        controller: _controller,
        autofocus: true,
        cursorColor: widget.focusedColor,
        onChanged:  (name)=>widget.onChanged(name),
        onSubmitted: (_) => _handleSubmit(),
        decoration: InputDecoration(
          hintText:widget. hintText,
          filled: true,
          
          hintStyle:  PoppinsRegular(15, ColorsApp.ThirdColor),
          fillColor: Colors.white,
          border: border(ColorsApp.textColor),
          focusedBorder: border(widget.focusedColor),
          prefixIcon: IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red),
            onPressed: widget.onCancel,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.green),
            onPressed: _handleSubmit,
          ),
        ),
        onTap: () {}, // block propagation
      ),
    );
  }
}
