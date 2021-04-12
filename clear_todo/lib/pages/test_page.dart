import 'package:flutter/material.dart';

double _width = 400.0;
const double HEIGHT_ITEM=100;
class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  double x = 0;
  double y = 0;
  double z = 0;

  double positionY = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {
            print("details " + details.delta.dy.toString());
            setState(() {
              positionY =(positionY+ details.delta.dy).clamp(0.0, HEIGHT_ITEM);

            });
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: listTasks(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> listTasks() {
    List<Widget> results = [];
    for (int i = 0; i < 30; i++) {
      double translateY = positionY;
      results.add(Transform.translate(
        offset: Offset(0,translateY),
        child: Container(
          height: HEIGHT_ITEM,
          color: Colors.red,
          margin: EdgeInsets.only(bottom: 10),
        ),
      ));
    }
    return results;
  }
}
