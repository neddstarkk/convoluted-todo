import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/provider/todo_model.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo/screens/widgets/time_button.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final taskTitleController = TextEditingController();
  bool completedStatus = false;
  bool setReminder = false;
  String _date = "Today";
  String _time = "Not set";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    _time = DateFormat('kk:mm').format(now);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    taskTitleController.dispose();
    super.dispose();
  }

  void onAdd() {
    final String textval = taskTitleController.text;
    final bool completed = completedStatus;

    if (textval.isNotEmpty) {
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
                    title: Text("Complete"),
                  ),
                  CheckboxListTile(
                    value: setReminder,
                    onChanged: (checked) {
                      setState(() {
                        setReminder = checked;
                      });
                    },
                    title: Text("Set Reminder"),
                  ),
                  ListTile(
                    enabled: setReminder,
                    title: MaterialButton(
                      elevation: 4.0,
                      onPressed: setReminder
                          ? () {
                              DatePicker.showDateTimePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime.now(),
                                  maxTime: DateTime(2022, 12, 31),
                                  onConfirm: (dateTime) {
                                print("Confirm: $dateTime");
                                if (dateTime.day == DateTime.now().day) {
                                  _date = "Today";
                                } else {
                                  _date =
                                      '${dateTime.day}-${dateTime.month}-${dateTime.year}';
                                }
                                if(dateTime.minute < 10) {
                                  _time = '${dateTime.hour}:0${dateTime.minute}';
                                }
                                else {
                                  _time = '${dateTime.hour}:${dateTime.minute}';
                                }
                                setState(() {});
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                              setState(() {});
                            }
                          : null,
                      child: Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  Icon(Icons.access_time),
                                  Text("$_date $_time"),
                                ],
                              ),
                            ),
                            Text("Change")
                          ],
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text("Add"),
                    onPressed: () {
                      onAdd();
                    },
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
