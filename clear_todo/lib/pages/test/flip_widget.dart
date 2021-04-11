import 'package:flutter/material.dart';
import 'dart:math' as math;
class FlipWidget extends StatelessWidget {
  final Widget child;

  FlipWidget({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform(
          transform: Matrix4(
            1,0,0,0,
            0,1,0,0,
            0,0,1,0.006,
            0,0,0,1,
          )..rotateX(math.pi/4),
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
            0,0,1,0.006,
            0,0,0,1,
          )..rotateX(-math.pi/3),
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
