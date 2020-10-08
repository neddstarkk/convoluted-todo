import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/models/tasks.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // singleton database helper
  static Database _database; // singleton database

  String todoTable = 'task_table';
  String colId = "id";
  String colTitle = "title";
  String colCompleted = 'completed';

  DatabaseHelper.createInstance(); // Named constructor to create instance of this class

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper.createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialiseDatabase();
    }

    return _database;
  }

  Future<Database> initialiseDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todos.db';

    // open/create the database at a given path
    var todosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return todosDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $todoTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colCompleted INTEGER)');
  }

  // Fetch Operation: Get all task objects from database
  Future<List<Map<String, dynamic>>> getTodoMapList() async {
    Database db = await this.database;

    var result = await db.query(todoTable, orderBy: '$colId ASC');
    return result;
  }

  // Insert Operation: Insert a todo object to database
  Future<int> insertTodo(Task task) async {
    Database db = await this.database;
    var result = await db.insert(todoTable, task.toMap());
    return result;
  }

  // Update Operation: Update a task object and save it to database
  Future<int> updateTodoCompleted(Task task) async {
    var db = await this.database;
    var result = await db.update(todoTable, task.toMap(), where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  // Delete Operation: Delete a task object from database
  Future<int> deleteTodo(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $todoTable WHERE $colId = $id');
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'todo List' [ List<Todo> ]
  Future<List<Task>> getTaskList() async {

    var taskMapList = await getTodoMapList(); // Get 'Map List' from database
    int count = taskMapList.length;         // Count the number of map entries in db table

    List<Task> taskList = List<Task>();
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      taskList.add(Task.fromMapObject(taskMapList[i]));
    }

    return taskList;
  }
}
