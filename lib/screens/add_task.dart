import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/tasks.dart';
import 'package:todo/provider/todo_model.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/widgets/time_button.dart';
import 'package:timezone/timezone.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final taskTitleController = TextEditingController();
  bool completedStatus = false;
  bool setReminder = false;
  String _dateString = "Today";
  String _timeString = "Not set";
  DateTime _dateTime;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dateTime = DateTime.now();
    _timeString = DateFormat('kk:mm').format(_dateTime);

    var initializationSettingsAndroid =
        AndroidInitializationSettings('flutter_devs');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<dynamic> onSelectNotification(String payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomeScreen()));
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

  Future<void> scheduleNotification() async {
    Location location = Location("IST", [], [], []);
    TZDateTime scheduleNotificationDateTime = TZDateTime(
      location,
      _dateTime.year,
      _dateTime.month,
      _dateTime.day,
      _dateTime.hour,
      _dateTime.minute,
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iosPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics);

    var uiLocalNotificationDateInterpretation =
        UILocalNotificationDateInterpretation.absoluteTime;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'scheduled body',
      scheduleNotificationDateTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          uiLocalNotificationDateInterpretation,
      androidAllowWhileIdle: true,
    );
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
                                _dateTime = dateTime;
                                if (dateTime.day == DateTime.now().day) {
                                  _dateString = "Today";
                                } else {
                                  _dateString =
                                      '${dateTime.day}-${dateTime.month}-${dateTime.year}';
                                }
                                if (dateTime.minute < 10) {
                                  _timeString =
                                      '${dateTime.hour}:0${dateTime.minute}';
                                } else {
                                  _timeString =
                                      '${dateTime.hour}:${dateTime.minute}';
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
                                  Text("$_dateString $_timeString"),
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
                      scheduleNotification();
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
