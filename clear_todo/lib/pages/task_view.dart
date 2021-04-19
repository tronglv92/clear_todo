import 'package:clear_todo/models/task.dart';
import 'package:flutter/material.dart';

import 'flutter_reorderable_list.dart';

const double TASK_HEIGHT = 64;

class TaskView extends StatelessWidget {
  final Task task;

  TaskView({this.task,@required Key key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration:
      BoxDecoration(

        // border: Border.all(color: Colors.black, width: 1),
        color: task?.color,
      ),
      padding: EdgeInsets.all(8),
      height: TASK_HEIGHT,
      child: Center(
        child: Text(
          task != null ? task.name : "New Task",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
