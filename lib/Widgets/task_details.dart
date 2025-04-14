import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tasker/Widgets/circle_container.dart';
import 'package:tasker/models/task_model.dart';
import 'package:tasker/ui/views/home/home_viewmodel.dart';
import 'package:tasker/utils/extensions.dart';

class TaskDetails extends StatelessWidget {
  final Task task;
  final HomeViewModel viewModel; // Add HomeViewModel to access summary data

  const TaskDetails({super.key, required this.task, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme;
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleContainer(
              color: task.category.color.withOpacity(0.3),
              child: Icon(
                task.category.icon,
                color: task.category.color,
              ),
            ),
            const Gap(16),
            Text(
              task.title,
              style: style.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              task.time,
              style: style.titleMedium,
            ),
            const Gap(16),
            Visibility(
              visible: task.isCompleted,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Task completed on ${task.date}'),
                  Icon(
                    Icons.check_box,
                    color: task.category.color,
                  ),
                ],
              ),
            ),
            const Gap(16),
            Divider(
              thickness: 1.5,
              color: task.category.color,
            ),
            const Gap(16),
            Text(
              task.note.isEmpty
                  ? 'There is no additional note for this task'
                  : task.note,
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            // Summary Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Summary',
                    style: style.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Gap(8),
                  Text('Total Tasks: ${viewModel.totalTasks}'),
                  const Gap(8),
                  Text(
                      'Completed: ${viewModel.completePercentage.toStringAsFixed(1)}%'),
                  const Gap(8),
                  LinearProgressIndicator(
                    value: viewModel.completePercentage / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const Gap(8),
                  Text('High Priority Tasks: ${viewModel.highPriorityCount}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
