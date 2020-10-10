import 'package:flutter/material.dart';
import 'package:todo/screens/add_task.dart';
import 'package:todo/screens/all_tasks.dart';
import 'package:todo/screens/completed_tasks.dart';
import 'package:todo/screens/incomplete_tasks.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
