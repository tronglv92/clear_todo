import 'package:clear_todo/helper/animated_interpolation.dart';
import 'package:clear_todo/pages/flip_task.dart';

import 'package:clear_todo/pages/task.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class NewTask extends StatelessWidget {
  final Color color;
  final String task;
  final double translationY;
  final double scale;

  NewTask(
      {this.color = Colors.red,
      this.translationY,
      this.task = "New Task",
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
      child: FlipTask(
        scale: scale,
        child: Stack(
          children: [
            Task(
              color: color,
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
