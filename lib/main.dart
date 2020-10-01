import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todo/provider/todo_model.dart';
import 'package:todo/screens/home_screen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoModel(),
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
