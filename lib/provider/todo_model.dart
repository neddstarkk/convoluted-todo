import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/database/database_helper.dart';
import 'package:todo/models/tasks.dart';

class TodoModel extends ChangeNotifier {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Task> tasks = [];

  UnmodifiableListView<Task> get allTasks => UnmodifiableListView(tasks);

  UnmodifiableListView<Task> get completeTasks =>
      UnmodifiableListView(tasks.where((todo) => todo.completed));

  UnmodifiableListView<Task> get incompleteTasks =>
      UnmodifiableListView(tasks.where((todo) => !todo.completed));

  void addTodo(Task task) async {
    tasks.add(task);
    int result = await databaseHelper.insertTodo(task);
    print(result);
    notifyListeners();
  }

  void toggleTodo(Task task) {
    final taskIndex = tasks.indexOf(task);
    tasks[taskIndex].toggleComplete();
    notifyListeners();
  }

  void deleteTodo(Task task) async {
    tasks.remove(task);
    int result = await databaseHelper.deleteTodo(task.id);
    print(result);
    notifyListeners();
  }

  void updateTaskList() {
    final Future<Database> dbFuture = databaseHelper.initialiseDatabase();
    dbFuture.then((database) {
      Future<List<Task>> taskListFuture = databaseHelper.getTaskList();
      taskListFuture.then((todoList) {
        this.tasks = todoList;
        notifyListeners();
      });
    });
  }
}
