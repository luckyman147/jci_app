import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import '../../../../../core/app_theme.dart';

class CommentInputField extends StatefulWidget {

  final String teamId;
  final String taskId;
  final void Function(String) onSend;

  const CommentInputField({
    super.key,
     required this. teamId,
    required this.taskId,

    required this.onSend,
  });

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
   final TextEditingController _controller=TextEditingController();
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
  }

  void _toggleEmojiPicker() {
    FocusScope.of(context).unfocus();
    setState(() => _showEmojiPicker = !_showEmojiPicker);
  }

  void _submitComment() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  void _onEmojiSelected(Emoji emoji) {
    _controller.text += emoji.emoji;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty= _controller.text.isEmpty;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: TextField(
            minLines:1,
            maxLines: 3,
            controller: _controller,
            onChanged: (value){
              setState(() {
                isEmpty=_controller.text.isEmpty;
              });
            },
            style: PoppinsRegular(12, ColorsApp.textColorBlack),
            decoration: InputDecoration(
              hintText: 'Send a comment',
              hintStyle: PoppinsRegular(12, ColorsApp.ThirdColor),


              prefixIcon: IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined),
                onPressed: _toggleEmojiPicker,
              ),

              suffixIcon: IconButton(
                icon:  Icon(Icons.send,color: isEmpty?ColorsApp.ThirdColor:PrimaryColor,),
                onPressed: _submitComment,
              ),
              border: border(ThirdColor),
              focusedBorder: border(PrimaryColor),

              enabledBorder: border(PrimaryColor),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            onSubmitted: (_) => _submitComment(),
          ),
        ),
        if (_showEmojiPicker)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) => _onEmojiSelected(emoji),

            ),
          ),
      ],
    );
  }
}
