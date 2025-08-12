import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Teams/domain/dto/TaskIdParams.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';

import '../../../../../core/app_theme.dart';
import '../../../domain/entities/task/Task.dart';

class TaskInputField extends StatefulWidget {
  final TaskCompletionStatus status;
  final String teamId;
final Color color ;
  const TaskInputField({super.key, required this.status,
    required this. color,
    required this.teamId});


  @override
  State<TaskInputField> createState() => _TaskInputFieldState();
}

class _TaskInputFieldState extends State<TaskInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_updateState);
    _controller.addListener(_updateState);
  }

  void _updateState() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _addTask() {
    final value = _controller.text.trim();
    if (value.isNotEmpty) {
      final newTask = AddTaskParams(
        null,
        teamId: widget.teamId,
        name: value,
        status: widget.status,
      );
      context.read<GetTaskBloc>().add(CreateTask(newTask));
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_updateState);
    _controller.removeListener(_updateState);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(

        cursorColor: widget.color,
        controller: _controller,
        focusNode: _focusNode,
        onSubmitted: (_) => _addTask(),
        decoration: InputDecoration(

          hintText: 'Add task',
          suffixIcon: (_isFocused && _hasText)
              ? IconButton(
            icon:  Icon(Icons.check_circle,color: widget.color,),
            onPressed: _addTask,
          )
              : null,
          border: border(widget.color),
          focusedBorder: border(widget.color),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}

