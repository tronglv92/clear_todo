import 'package:clear_todo/helper/animated_helper.dart';
import 'package:clear_todo/helper/animated_interpolation.dart';
import 'package:clear_todo/pages/test/item_test.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

double _width = 400.0;

enum StatusScroll { NONE, START, END, UPDATE, OVER_SCROLL }

const double HEIGHT_ITEM = 64;

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with TickerProviderStateMixin {
  double overScroll = 0;
  double scrollPosition = 0;
  AnimationController _controllerSpring;
  Animation<double> _animationSpring;
  StatusScroll statusScroll = StatusScroll.NONE;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAnimation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerSpring?.dispose();
    super.dispose();
  }

  void initAnimation() {
    _controllerSpring =
        AnimationController(vsync: this, lowerBound: -500, upperBound: 500)
          ..addListener(() {
            setState(() {
              overScroll = _animationSpring?.value;
            });
          })
          ..addStatusListener((AnimationStatus status) {
            // runSpringComplete = true;
            if (status == AnimationStatus.completed) {}
          });
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {

    } else if (notification is ScrollEndNotification) {

      statusScroll = StatusScroll.END;
      _animationSpring =
          _controllerSpring?.drive(Tween(begin: overScroll, end: 0));
      AnimatedHelper.runAnimateSpring(
        begin: overScroll,
        end: 0,
        controllerSpring: _controllerSpring,
      );
    } else if (notification is ScrollUpdateNotification) {
      setState(() {
        statusScroll = StatusScroll.UPDATE;

        scrollPosition = notification.metrics.pixels;
      });
    } else if (notification is OverscrollNotification) {
      print("OverscrollNotification ");

      setState(() {
        statusScroll = StatusScroll.OVER_SCROLL;
        overScroll =
            (overScroll + notification.overscroll).clamp(-HEIGHT_ITEM, 0.0);
      });

    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double rotationX = -math.pi/2;

    double positionTaskNew = -HEIGHT_ITEM;

    double translationY =
        (-overScroll - scrollPosition).clamp(0.0, HEIGHT_ITEM);



    positionTaskNew = InterpolationTween(
            inputRange: [0, HEIGHT_ITEM],
            outputRange: [-HEIGHT_ITEM, 0],
            extrapolate: ExtrapolateType.clamp)
        .transform(translationY);
    rotationX = InterpolationTween(
            inputRange: [0, HEIGHT_ITEM],
            outputRange: [ -math.pi/2,0],
            extrapolate: ExtrapolateType.clamp)
        .transform(translationY);



    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (DragUpdateDetails details) {


          },
          onLongPressStart: (LongPressStartDetails longPressStart){
            print("longPressStart "+longPressStart.toString());
          },
          onLongPressMoveUpdate: (LongPressMoveUpdateDetails longPressUpdate){
            print("longPressUpdate "+longPressUpdate.localPosition.toString());
          },
          onLongPressEnd: (LongPressEndDetails longPressEnd){
            print("longPressEnd "+longPressEnd.toString());
          },
          child: Stack(
            children: [
              NotificationListener(
                onNotification: onNotification,
                child: ListView(
                  // onReorder: (int oldIndex, int newIndex) {
                  //   setState(() {
                  //     if (oldIndex < newIndex) {
                  //       newIndex -= 1;
                  //     }
                  //     // final int item = _items.removeAt(oldIndex);
                  //     // _items.insert(newIndex, item);
                  //   });
                  // },
                  physics: ClampingScrollPhysics(),
                  children: listTasks(),
                ),
              ),
              Positioned(
                height: HEIGHT_ITEM,
                width: MediaQuery.of(context).size.width,
                top: positionTaskNew,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateX(rotationX),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: HEIGHT_ITEM,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      color: Colors.blue,
                    ),
                  ),
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
      results.add(ItemTest(
        key: Key('$i'),
        index: i,

        overScroll: overScroll,
      ));
    }
    return results;
  }
}
