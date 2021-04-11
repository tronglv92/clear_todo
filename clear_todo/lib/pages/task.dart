import 'package:flutter/material.dart';
const double TASK_HEIGHT = 64;
class Task extends StatelessWidget {
  final Color color;
  final String task;
  Task({this.color,this.task});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,

      padding: EdgeInsets.all(8),
      height: TASK_HEIGHT,
      child: Center(
        child: Text(
          task,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
