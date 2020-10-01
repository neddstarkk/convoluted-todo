import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/provider/todo_model.dart';
import 'package:todo/screens/widgets/task_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CompletedTasks extends StatelessWidget {
  Future<List<Task>> tasks() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    final Database db = await openDatabase(path);

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM todos WHERE completed = 1');

    return List.generate(maps.length, (index) {
      return Task(
        id: maps[index]['id'],
        title: maps[index]['title'],
        completed: true
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
              builder: (context, todos, child) => TaskList(
                tasks: snapshot.data,
              ),
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
