import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/todo_model.dart';
import 'package:todo/screens/widgets/task_list.dart';
import 'package:todo/screens/widgets/task_list_item.dart';

class AllTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<TodoModel>(
        builder: (context, todo, child) => TaskList(
          tasks: todo.allTasks
        ),
      ),
    );
  }
}
