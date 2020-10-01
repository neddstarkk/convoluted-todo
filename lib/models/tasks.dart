import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Task {
  int id;
  String title;
  bool completed;

  Task({@required this.title, this.completed = false, this.id});

  void toggleComplete() {
    completed = !completed;
  }

  Map<String, dynamic> toMap() {
    int complete = completed ? 1 : 0;

    return {
      'id': id,
      'title': title,
      'completed': complete,
    };
  }

  Future<void> insertTask(Task task, int id) async {
    final Database db =
        await openDatabase(join(await getDatabasesPath(), 'todo.db'));

    task.id = id;
    await db.insert('todos', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateTask(Task task, int id, bool completed) async {
    final Database db = await openDatabase(join(await getDatabasesPath(), 'todo.db'));

    task.completed = completed == true ? false : true;
    Map map = task.toMap();
    map[id] = task.completed == true ? 1 : 0;

    await db.update('todos', map, where: "id = ?", whereArgs: [task.id]);
  }
}
