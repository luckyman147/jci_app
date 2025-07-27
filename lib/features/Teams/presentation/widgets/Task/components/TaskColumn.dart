import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';

import '../../../../../Home/Activity_Global.dart';
import '../../../../domain/entities/task/Task.dart';

class TaskColumn extends StatelessWidget {
  final String title;
  final TaskStatus status;
  final Color color;
  final List<Tasks> tasks;

  const TaskColumn({
    super.key,
    required this.title,
    required this.status,
    required this.color,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Expanded(
      child: DragTarget<Tasks>(
        onAcceptWithDetails: (data) => data.data.meta.status != status,
        onAccept: (task) {
          context.read<GetTaskBloc>().add(UpdateStatus(task, status));},
        builder: (context, _, __) => Card(
          color: color.withOpacity(0.08),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: color,
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: controller,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      context.read<TaskBloc>().add(AddTask(value, status));
                      controller.clear();
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: 'Add task',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return LongPressDraggable<Tasks>(
                      data: task,
                      feedback: Material(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.grey[300],
                          child: Text(task.name),
                        ),
                      ),
                      child: Card(
                        child: ListTile(
                          title: Text(task.name),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
