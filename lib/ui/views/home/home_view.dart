import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tasker/Widgets/common_containers.dart';
import 'package:tasker/Widgets/display_white_text.dart';
import 'package:tasker/Widgets/task_details.dart';
import 'package:tasker/Widgets/task_tile.dart';
import 'package:tasker/app/app.locator.dart';
import 'package:tasker/service/task_service.dart';
import 'package:tasker/ui/common/app_colors.dart';
import 'package:tasker/ui/common/ui_helpers.dart';
import 'package:tasker/utils/extensions.dart';
import 'package:gap/gap.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final deviceSize = context.deviceSize;
    final colors = context.colorScheme;
    return Scaffold(
        body: Stack(
      children: [
        Column(children: [
          Container(
            height: deviceSize.height * 0.3,
            width: deviceSize.width,
            color: colors.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.summarize, color: Colors.white),
                  onPressed: () => viewModel.navigateToTaskSummary(),
                  tooltip: 'View Task Summary',
                ),
                const DisplayWhiteText(
                  text: "TASKER",
                  fontSize: 40,
                ),
              ],
            ),
          )
        ]),
        Positioned(
          top: 130,
          left: 0,
          right: 0,
          child: SafeArea(
              child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _DisplayListOfTasks(
                        viewModel: viewModel,
                        isCompleted: false,
                        emptyMessage: 'No incomplete tasks',
                      ),
                      const Gap(20),
                      Text('completed',
                          style: context.textTheme.headlineMedium),
                      const Gap(20),
                      _DisplayListOfTasks(
                        viewModel: viewModel,
                        isCompleted: true,
                        emptyMessage: 'No completed tasks',
                      ),
                      const Gap(20),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(colors.primary)),
                        onPressed: () async {
                          final result = await viewModel.navigateToCreateTask();
                          if (result == true) {
                            await viewModel.reloadTasks();
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DisplayWhiteText(text: 'Add New'),
                        ),
                      ),
                    ],
                  ))),
        )
      ],
    ));
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) =>
      HomeViewModel(locator<TaskService>());

  @override
  void onViewModelReady(HomeViewModel viewModel) async {
    await viewModel.initialise();
  }
}

//using private for task list section
class _DisplayListOfTasks extends StatelessWidget {
  final HomeViewModel viewModel;
  final bool isCompleted;
  final String emptyMessage;

  const _DisplayListOfTasks({
    required this.viewModel,
    required this.isCompleted,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = context.deviceSize;
    final height =
        isCompleted ? deviceSize.height * 0.25 : deviceSize.height * 0.3;
    final tasks = isCompleted
        ? viewModel.tasks.where((task) => task.isCompleted).toList()
        : viewModel.tasks.where((task) => !task.isCompleted).toList();
    print('--------------------');
    print(isCompleted);
    print(tasks.length);
    return CommonContainers(
        height: height,
        child: tasks.isEmpty
            ? Center(
                child: Text(
                  emptyMessage,
                  style: context.textTheme.headlineSmall,
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (ctx, index) {
                  final task = tasks[index];
                  return InkWell(
                      onTap: () async {
                        await showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return TaskDetails(
                                  task: task, viewModel: viewModel);
                            });
                      },
                      onLongPress: () =>
                          viewModel.showDeleteConfirmation(task.id!),
                      child: TaskTile(
                        task: task,
                        onCompleted: (value) =>
                            viewModel.updateTask(task.id!, isCompleted: value),
                      ));
                },
                separatorBuilder: (context, index) =>
                    const Divider(thickness: 2.0),
                itemCount: tasks.length,
              ));
  }
}
