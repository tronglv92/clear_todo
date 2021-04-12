import 'package:clear_todo/helper/animated_interpolation.dart';
import 'package:clear_todo/models/task.dart';
import 'package:clear_todo/pages/flip_task.dart';

import 'package:clear_todo/pages/task_view.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class NewTask extends StatelessWidget {

  final Task task;
  final double translationY;
  final double scale;

  NewTask(
      {
      this.translationY,
      this.task ,
      this.scale});

  @override
  Widget build(BuildContext context) {
    const List<double> inputRange = [0, 2];
    double opacity = InterpolationTween(
            inputRange: inputRange,
            outputRange: [0.5, 0],
            extrapolate: ExtrapolateType.clamp)
        .transform(scale);
    return Positioned(
      height: TASK_HEIGHT,
      top: translationY,
      width: MediaQuery.of(context).size.width,
      // child: TaskView(
      //   task: task,
      // ),
      child: FlipTask(
        scale: scale,
        child: Stack(
          children: [
            TaskView(

              task: task,
            ),
            Positioned.fill(
                child: Opacity(
                    opacity: opacity,
                    child: Container(
                      color: Colors.black,
                    )))
          ],
        ),
      ),
    );
  }
}
