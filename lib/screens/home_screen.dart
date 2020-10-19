import 'package:flutter/material.dart';
import 'package:todo/screens/add_task.dart';
import 'package:todo/screens/all_tasks.dart';
import 'package:todo/screens/completed_tasks.dart';
import 'package:todo/screens/incomplete_tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool authRequired = false;

  @override
  void initState() {
    // TODO: implement initState
    initializeAuthRequired();
    super.initState();
  }

  initializeAuthRequired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authRequired = prefs.getBool("FingerPrint");
  }

  addBoolToSP(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("FingerPrint", value);
    prefs.reload();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Todos"),
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
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 200,
                color: Colors.blue,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("Require Fingerprint"),
                    ),
                    Switch(
                      value: authRequired,
                      onChanged: (bool val) {
                        setState(() {
                          authRequired = !authRequired;
                          addBoolToSP(authRequired);
                        });
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AllTasks(),
            CompletedTasks(),
            IncompleteTasks(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTaskScreen(),
                ),
              );
            },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
