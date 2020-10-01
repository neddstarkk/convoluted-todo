import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/screens/widgets/task_list_item.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  TaskList({@required this.tasks});



  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getChildrenTasks(),
    );
  }

  List<Widget> getChildrenTasks() {
    var something =  tasks.map((todo) => TaskListItem(task: todo)).toList();
    print(something);
    return something;
  }
}
