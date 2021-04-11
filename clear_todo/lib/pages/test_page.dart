import 'package:flutter/material.dart';

double _width = 400.0;
class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  double x = 0;
  double y = 0;
  double z = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform(
          transform: Matrix4(
            1,0,0,0,
            0,1,0,0,
            0,0,1,0.002,
            0,0,0,1,
          )..rotateY(y),
          alignment: FractionalOffset.center,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                y = y - details.delta.dx / 100;
                x = x + details.delta.dy / 100;
              });
            },
            child: Container(
              color: Colors.red,
              height: 200.0,
              width: 200.0,
            ),
          ),
        ),
      ),
    );
  }
}
