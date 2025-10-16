import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/domain/entities/task.dart';
import 'package:task_management_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:task_management_app/presentation/bloc/task/task_bloc.dart';
import 'package:task_management_app/presentation/widgets/add_task_sheet.dart';
import 'package:task_management_app/presentation/widgets/task_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  Map<String, List<Task>> _groupTasks(List<Task> tasks) {
    tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    final groupedTasks = <String, List<Task>>{
      'Today': [],
      'Tomorrow': [],
      'This Week': [],
      'Later': [],
    };

    for (final task in tasks) {
      final taskDate =
          DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      if (taskDate.isAtSameMomentAs(today)) {
        groupedTasks['Today']!.add(task);
      } else if (taskDate.isAtSameMomentAs(tomorrow)) {
        groupedTasks['Tomorrow']!.add(task);
      } else if (taskDate.isAfter(tomorrow) &&
          taskDate.isBefore(today.add(const Duration(days: 7)))) {
        groupedTasks['This Week']!.add(task);
      } else {
        groupedTasks['Later']!.add(task);
      }
    }
    return groupedTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _HomeAppBar(),
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TasksLoadInProgress) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is TasksLoadSuccess) {
                    final filteredTasks = state.filteredTasks;
                    if (filteredTasks.isEmpty) {
                      return const Center(child: Text('No tasks found.'));
                    }
                    final groupedTasks = _groupTasks(filteredTasks);

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: groupedTasks.entries.map((entry) {
                        final title = entry.key;
                        final tasks = entry.value;

                        if (tasks.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8.0, top: 16.0),
                              child: Text(title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontSize: 18)),
                            ),
                            ...tasks.map((task) {
                              return TaskListItem(task: task);
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    );
                  }
                  return const Center(child: Text('Failed to load tasks.'));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskSheet(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            final activeFilter =
                state is TasksLoadSuccess ? state.filter : TaskFilter.all;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.list_alt_rounded),
                  color: activeFilter == TaskFilter.all
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  onPressed: () {
                    context
                        .read<TaskBloc>()
                        .add(UpdateFilterEvent(TaskFilter.all));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  color: activeFilter != TaskFilter.all
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  onPressed: () {
                    final newFilter = activeFilter == TaskFilter.completed
                        ? TaskFilter.incomplete
                        : TaskFilter.completed;
                    context.read<TaskBloc>().add(UpdateFilterEvent(newFilter));
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Today, ${DateFormat('d MMM').format(DateTime.now())}',
                  style: const TextStyle(color: Colors.grey)),
              Row(
                children: [
                  // THIS IS THE FIX: Added the priority filter menu back in
                  BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, state) {
                      final activePriority = state is TasksLoadSuccess
                          ? state.priorityFilter
                          : null;
                      return PopupMenuButton<Priority?>(
                        icon: Icon(
                          Icons.filter_list_rounded,
                          color: activePriority != null
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                        onSelected: (Priority? priority) {
                          context
                              .read<TaskBloc>()
                              .add(UpdatePriorityFilterEvent(priority));
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem<Priority?>(
                              value: null,
                              child: Text('All Priorities'),
                            ),
                            ...Priority.values.map((priority) {
                              return PopupMenuItem<Priority?>(
                                value: priority,
                                child: Text(priority
                                    .toString()
                                    .split('.')
                                    .last
                                    .toUpperCase()),
                              );
                            }),
                          ];
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                  ),
                ],
              ),
            ],
          ),
          Text('My Tasks',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 28)),
        ],
      ),
    );
  }
}
