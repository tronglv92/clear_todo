import 'package:flutter/material.dart';

import 'personal_list_page.dart';
class NewTaskOverScroll extends StatelessWidget {
  final double translateY;
  final double rotateX;
  NewTaskOverScroll({this.translateY,this.rotateX});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: TASK_HEIGHT,
      width: MediaQuery.of(context).size.width,
      top: translateY,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateX(rotateX),
        alignment: Alignment.bottomCenter,
        child: Container(
          height: TASK_HEIGHT,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
