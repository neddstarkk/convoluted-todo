import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/provider/todo_model.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  TaskListItem({@required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (bool checked) {
          Provider.of<TodoModel>(context, listen: false).toggleTodo(task);
        },
      ),
      title: Text(task.title),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red,),
        onPressed: () {
          Provider.of<TodoModel>(context, listen: false).deleteTodo(task);
        },
      ),
    );
  }
}
