import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/provider/todo_model.dart';
import 'package:todo/screens/fingerprint_auth.dart';
import 'package:todo/screens/home_screen.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool boolValue;

  Future<bool> checkAuthRequired() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    boolValue = prefs.getBool("FingerPrint");
    return boolValue;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthRequired();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoModel(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(),
          home: boolValue == true ? FingerprintAuth() : HomeScreen()),
    );
  }
}
