import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stacked/stacked.dart';
import 'package:tasker/Widgets/display_white_text.dart';
import 'package:tasker/utils/extensions.dart';

import 'task_summary_viewmodel.dart';

class TaskSummaryView extends StackedView<TaskSummaryViewModel> {
  const TaskSummaryView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TaskSummaryViewModel viewModel,
    Widget? child,
  ) {
    final style = context.textTheme;
    final colors = context.colorScheme;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: colors.primary,
          title: const DisplayWhiteText(text: 'Task Summary'),
          leading: IconButton(
              onPressed: () => viewModel.navigateBack(),
              icon: const Icon(Icons.arrow_back_ios_new_sharp,
                  color: Colors.white)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Summary',
                style: style.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Tasks: ${viewModel.totalTasks}'),
                    const Gap(8),
                    Text(
                        'Completed: ${viewModel.completedPercentage.toStringAsFixed(1)}%'),
                    const Gap(8),
                    LinearProgressIndicator(
                      value: viewModel.completedPercentage / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    const Gap(8),
                    Text('High Priority Tasks: ${viewModel.highPriorityCount}'),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  @override
  TaskSummaryViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TaskSummaryViewModel();
}
