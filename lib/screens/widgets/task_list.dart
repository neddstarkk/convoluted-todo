import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/database_helper.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/provider/todo_model.dart';
import 'package:todo/screens/widgets/task_list_item.dart';

int i = 1;

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  TaskList({@required this.tasks});

  @override
  Widget build(BuildContext context) {
    if(Provider.of<TodoModel>(context).tasks.isEmpty && i > 0) {
      Provider.of<TodoModel>(context).updateTaskList();
      i = 0;
    }

    return ListView(
      children: getChildrenTasks(),
    );
  }

  List<Widget> getChildrenTasks() {
    return tasks.map((todo) => TaskListItem(task: todo)).toList();
  }
}
