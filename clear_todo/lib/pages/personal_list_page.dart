import 'dart:async';


import 'package:clear_todo/helper/animated_helper.dart';
import 'package:clear_todo/helper/animated_interpolation.dart';
import 'package:clear_todo/pages/new_task.dart';
import 'package:clear_todo/pages/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

const double TASK_HEIGHT = 64;

class PersonalListPage extends StatefulWidget {
  @override
  _PersonalListPageState createState() => _PersonalListPageState();
}

class _PersonalListPageState extends State<PersonalListPage>
    with TickerProviderStateMixin {
  AnimationController _controllerSpring;
  Animation<double> _animationSpring;

  List<String> tasks = [
    "Swipe to the right to complete!",
    "Swipe to the left to delete",
    "Tap and hold to pick me up",
    "Pull down to create an item",
    "Try shaking to undo",
    "Try pincing vertically shut",
    "Pull up to clear",
  ];

  ColorInterpolationTween ipColor;

  double focalY = 0;
  double scale = 0;
  double scaleRaw=1;
  int index=0;
  bool runAnimationSpring=false;
  bool isRunningScale=false;
  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initInterpolation();
    initAnimation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  void initAnimation() {
    _controllerSpring =
        AnimationController(vsync: this, lowerBound: -500, upperBound: 500)
          ..addListener(() {

            if(runAnimationSpring==true)
              {

                setState(() {
                  print("vao trong nay1 ");
                  scale=_animationSpring?.value;
                });
              }





          })
          ..addStatusListener((AnimationStatus status) {
            // runSpringComplete = true;
              if(status==AnimationStatus.completed)
                {
                  runAnimationSpring=false;

                }

          });
  }

  void initInterpolation() {
    ipColor = ColorInterpolationTween(inputRange: [
      0,
      (tasks.length - 1).toDouble()
    ], outputRange: [
      Color.fromRGBO(197, 43, 39, 1.0),
      Color.fromRGBO(225, 176, 68, 1.0)
    ], extrapolate: ExtrapolateType.clamp);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerSpring?.dispose();
    _timer.cancel();
    super.dispose();

  }
  AppBar appBar = AppBar(
    title: Text('Personal List'),
  );
  @override
  Widget build(BuildContext context) {
    index=((focalY/TASK_HEIGHT).round());

    return Scaffold(
      appBar: appBar,
      body: SafeArea(

        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onScaleStart: (ScaleStartDetails scaleStart) {
            if(scaleStart.pointerCount==2)
              {
                isRunningScale=true;

                this.setState(() {
                  focalY = scaleStart.localFocalPoint.dy;
                });
              }


          },
          onScaleUpdate: (ScaleUpdateDetails scaleUpdate) {

            if(isRunningScale==true && scaleUpdate.pointerCount==2) {
              print("vao trong nay2 ");
              this.setState(() {
                scaleRaw = scaleUpdate.scale;
                scale = scaleRaw;
              });
            }
          },
          onScaleEnd: (ScaleEndDetails scaleEnd) {
            if(isRunningScale==true)
              {
                isRunningScale=false;
                runAnimationSpring=true;
                _animationSpring = _controllerSpring?.drive(Tween(begin: scaleRaw, end: 0));
                AnimatedHelper.runAnimateSpring(
                  begin: scaleRaw,
                  end: 0,
                  controllerSpring: _controllerSpring,

                );

              }



          },
          child: Stack(
            children: [

              Column(
                children: listTasks(),
              ),
              NewTask(translationY:index*TASK_HEIGHT-TASK_HEIGHT/2 ,scale: scale,color: ipColor.transform(index.toDouble()),),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> listTasks(){


    double scaleFactor =scale* (TASK_HEIGHT / 4);
    List<Widget> results=[];
    for (int i = 0; i < tasks.length; i++)
      {
        bool isOnTop = i< index;
        double translateY=scaleFactor*(isOnTop==true?-1:1);

        // print("======================>");
        // print("i "+i.toString());



        // print("<======================");
        results.add(Transform.translate(
          offset: Offset(0,translateY),
          child: Task(
            color: ipColor.transform(i.toDouble()),
            task: tasks[i],
          ),
        )) ;
      }
  return results;


  }
}
