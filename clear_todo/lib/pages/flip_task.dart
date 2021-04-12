import 'package:clear_todo/helper/animated_interpolation.dart';
import 'package:clear_todo/pages/personal_list_page.dart';
import 'package:flutter/material.dart';

import 'dart:math' as math;

class FlipTask extends StatelessWidget {
  final Widget child;
  final double scale;
  FlipTask({@required this.child,@required this.scale});


  @override
  Widget build(BuildContext context) {
    const List<double> inputRange = [0, 2];
    const double perspective=0.006;
    double rotateXTop=InterpolationTween(inputRange: inputRange, outputRange: [math.pi/2,0]).transform(scale);
    double rotateXBottom=InterpolationTween(inputRange: inputRange, outputRange: [-math.pi/2,0]).transform(scale);
    double translateZ=(-TASK_HEIGHT/2)*math.sin(rotateXTop.abs());
    double scaleFlip=500/(500-translateZ);


    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform(
          transform: Matrix4(
            1,0,0,0,
            0,1,0,0,
            0,0,1,perspective,
            0,0,0,1,
          )..rotateX(rotateXTop)..scale(scaleFlip),
          alignment: Alignment.bottomCenter,
          child: ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: 0.5,
              child: child,
            ),
          ),
        ),

        Transform(
          transform: Matrix4(
            1,0,0,0,
            0,1,0,0,
            0,0,1,perspective,
            0,0,0,1,
          )..rotateX(rotateXBottom)..scale(scaleFlip),
          alignment: Alignment.topCenter,
          child: ClipRect(
              child: Align(
                alignment: Alignment.bottomCenter,
                heightFactor: 0.5,
                child: child,
              )),
        ),
      ],

    );
  }
}
