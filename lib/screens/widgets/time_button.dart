import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';

class TimeButton extends StatefulWidget {
  final bool isDisabled;

  TimeButton({@required this.isDisabled});
  @override
  _TimeButtonState createState() => _TimeButtonState(isDisabled: isDisabled);
}

class _TimeButtonState extends State<TimeButton> {
  bool isDisabled;

  _TimeButtonState({this.isDisabled});

  @override
  Widget build(BuildContext context) {
    return isDisabled ? Text("Enabled") : Text("Disabled");
  }
}
