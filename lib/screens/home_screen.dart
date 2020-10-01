import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/todo_model.dart';
import 'package:todo/screens/add_task.dart';
import 'package:todo/screens/all_tasks.dart';
import 'package:todo/screens/completed_tasks.dart';
import 'package:todo/screens/incomplete_tasks.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  void openDB() async {
    String path = join(await getDatabasesPath(), 'todo.db');
    Database database = await openDatabase(
      path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, completed INT)');
      },
    );
  }

  void populateTaskList(BuildContext context) {
    Provider.of<TodoModel>(context, listen: false).updateTaskList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openDB();
  }

  @override
  Widget build(BuildContext context) {
    populateTaskList(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Todos"),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.add),
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "All",
                ),
                Tab(
                  text: "Complete",
                ),
                Tab(
                  text: "Incomplete",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AllTasks(),
              CompletedTasks(),
              IncompleteTasks(),
            ],
          )),
    );
  }
}
