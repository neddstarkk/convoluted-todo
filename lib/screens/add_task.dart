import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/provider/todo_model.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final taskTitleController = TextEditingController();
  bool completedStatus = false;

  @override
  void dispose() {
    // TODO: implement dispose
    taskTitleController.dispose();
    super.dispose();
  }

  void onAdd() {
    final String textval = taskTitleController.text;
    final bool completed = completedStatus;

    if(textval.isNotEmpty) {
      final Task todo = Task(
        title: textval,
        completed: completed,
      );
      
      Provider.of<TodoModel>(context, listen: false).addTodo(todo);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(controller: taskTitleController),
                  CheckboxListTile(
                    value: completedStatus,
                    onChanged: (checked) {
                      setState(() {
                        completedStatus = checked;
                      });
                    },
                    title: Text("Complete?"),
                  ),
                  RaisedButton(
                    child: Text("Add"),
                    onPressed: onAdd,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
