import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/tasks.dart';

class TodoModel extends ChangeNotifier {
  List<Task> _tasks = [];

  Future<List<Task>> getTasksFromDB() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    final Database db = await openDatabase(path);

    final List<Map<String, dynamic>> maps = await db.query('todos');

    return List.generate(maps.length, (index) {
      return Task(
          id: maps[index]['id'], title: maps[index]['title'], completed: true);
    });
  }


  UnmodifiableListView<Task> get allTasks => UnmodifiableListView(_tasks);

  UnmodifiableListView<Task> get completeTasks =>
      UnmodifiableListView(_tasks.where((todo) => todo.completed));

  UnmodifiableListView<Task> get incompleteTasks =>
      UnmodifiableListView(_tasks.where((todo) => !todo.completed));

  void addTodo(Task task) async {
    _tasks.add(task);
    await task.insertTask(task, _tasks.indexOf(task));
    notifyListeners();
  }

  void toggleTodo(Task task) async {
    final taskIndex = _tasks.indexOf(task);
    _tasks[taskIndex].toggleComplete();
    print("Here");
    await task.updateTask(task, taskIndex, task.completed);
    notifyListeners();
  }

  void deleteTodo(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void updateTaskList() async {
    Future<List<Task>> list = getTasksFromDB();
    _tasks = await list;
  }
}
