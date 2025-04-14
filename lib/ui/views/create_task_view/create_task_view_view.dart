import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:tasker/Widgets/circle_container.dart';
import 'package:tasker/Widgets/common_text_fields.dart';
import 'package:tasker/Widgets/display_white_text.dart';
import 'package:tasker/utils/extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tasker/utils/task_categories.dart';

import 'create_task_view_viewmodel.dart';

class CreateTaskViewView extends StackedView<CreateTaskViewViewModel> {
  const CreateTaskViewView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    CreateTaskViewViewModel viewModel,
    Widget? child,
  ) {
    final colors = context.colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: const DisplayWhiteText(
            text: 'Add New Task',
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextFields(
                title: "Task Title",
                hintText: "Enter task title",
                controller: viewModel.titleController,
              ),
              const Gap(16),
              _SelectCategory(viewModel: viewModel),
              const Gap(16),
              _SelectDateTime(viewModel: viewModel),
              const Gap(16),
              CommonTextFields(
                title: "Notes",
                hintText: "Enter task notes",
                maxlines: 6,
                controller: viewModel.noteController,
              ),
              const Gap(16),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(colors.primary)),
                onPressed: () async {
                  await viewModel.saveTask();
                  //Navigator.pop(context, true);
                },
                child: const DisplayWhiteText(text: "Save"),
              ),
            ],
          ),
        ));
  }

  @override
  CreateTaskViewViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      CreateTaskViewViewModel();
}

class _SelectDateTime extends StatelessWidget {
  final CreateTaskViewViewModel viewModel;
  const _SelectDateTime({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: CommonTextFields(
        title: "Date",
        hintText: DateFormat.yMMMd().format(viewModel.selectedDate),
        readOnly: true,
        suffixIcon: IconButton(
          onPressed: () => viewModel.selectDate(context),
          icon: const FaIcon(FontAwesomeIcons.calendar),
        ),
      )),
      const Gap(10),
      Expanded(
          child: CommonTextFields(
              title: "Time",
              hintText: viewModel.formatedTime,
              readOnly: true,
              suffixIcon: IconButton(
                onPressed: () => viewModel.selectTime(context),
                icon: const FaIcon(FontAwesomeIcons.clock),
              )))
    ]);
  }
}

// Inside create_task_view.dart
class _SelectCategory extends StatelessWidget {
  final CreateTaskViewViewModel viewModel;

  const _SelectCategory({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final categories = TaskCategories.values.toList();
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Text('Priority', style: Theme.of(context).textTheme.titleLarge),
          const Gap(10),
          Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                final category = categories[index];
                return InkWell(
                  onTap: () => viewModel.updateCategory(category),
                  borderRadius: BorderRadius.circular(30),
                  child: CircleContainer(
                    color: category.color.withOpacity(0.3),
                    child: Icon(
                      category.icon,
                      color: category == viewModel.selectedCategory
                          ? Theme.of(context).colorScheme.primary
                          : category.color,
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) => const Gap(8),
              itemCount: categories.length,
            ),
          ),
        ],
      ),
    );
  }
}
