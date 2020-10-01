import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/provider/todo_model.dart';
import 'package:todo/screens/widgets/task_list.dart';

class AllTasks extends StatelessWidget {

  Future<List<Task>> tasks() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    final Database db = await openDatabase(path);

    final List<Map<String, dynamic>> maps = await db.query('todos');

    return List.generate(maps.length, (index) {
      return Task(
        id: maps[index]['id'],
        title: maps[index]['title'],
        completed: maps[index]['completed'] == 1 ? true : false,
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: tasks(),
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.hasData) {
          return Container(
            child: Consumer<TodoModel>(
              builder: (context, todo, child) => TaskList(tasks: snapshot.data),
            ),
          );
        }
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
