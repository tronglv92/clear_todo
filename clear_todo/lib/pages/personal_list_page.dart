import 'dart:async';

import 'package:clear_todo/helper/animated_helper.dart';
import 'package:clear_todo/helper/animated_interpolation.dart';
import 'package:clear_todo/models/task.dart';
import 'package:clear_todo/pages/new_task.dart';
import 'package:clear_todo/pages/task_view.dart';
import 'package:clear_todo/helper/allow_multiple_scale_recognizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

const double TASK_HEIGHT = 64;

class PersonalListPage extends StatefulWidget {
  @override
  _PersonalListPageState createState() => _PersonalListPageState();
}

class _PersonalListPageState extends State<PersonalListPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  double scrollPosition = 0;

  AnimationController _controllerSpring;
  Animation<double> _animationSpring;

  // List<String> tasks = [
  //   "Swipe to the right to complete!",
  //   "Swipe to the left to delete",
  //   "Tap and hold to pick me up",
  //   "Pull down to create an item",
  //   "Try shaking to undo",
  //   "Try pincing vertically shut",
  //   "Pull up to clear",
  // ];

  ColorInterpolationTween ipColor;

  double focalY = 0;
  double scale = 0;
  double scaleRaw = 1;
  int index = 0;
  int indexNewTask = 0;
  bool runAnimationSpring = false;
  bool isRunningScale = false;
  Timer _timer;
  List<Task> tasks = [
    Task(name: "position 0"),
    Task(name: "position 1"),
    Task(name: "position 2"),
    Task(name: "position 3"),
    Task(name: "position 4"),
    Task(name: "position 5"),
    Task(name: "position 6"),
    Task(name: "position 7"),
    Task(name: "position 8"),
    Task(name: "position 9"),
    Task(name: "position 10"),
    Task(name: "position 11"),
    Task(name: "position 12"),
    Task(name: "position 13"),
    Task(name: "position 14"),
    Task(name: "position 15"),
    Task(name: "position 16"),
    Task(name: "position 17"),
    Task(name: "position 18"),
    Task(name: "position 19"),
    Task(name: "position 20"),
    Task(name: "position 21"),
    Task(name: "position 22"),
    Task(name: "position 23"),
    Task(name: "position 24"),
    Task(name: "position 25"),
    Task(name: "position 26"),
    Task(name: "position 27"),
    Task(name: "position 28"),
    Task(name: "position 29"),
    Task(name: "position 30"),
    Task(name: "position 31"),
    Task(name: "position 32"),
    Task(name: "position 33"),
    Task(name: "position 34")
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      scrollPosition = _scrollController.offset;
    });

    initInterpolation();
    initAnimation();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    setUpColorTasks();
  }

  void initAnimation() {
    _controllerSpring =
        AnimationController(vsync: this, lowerBound: -500, upperBound: 500)
          ..addListener(() {
            if (runAnimationSpring == true) {
              setState(() {
                scale = _animationSpring?.value;
              });
            }
          })
          ..addStatusListener((AnimationStatus status) {
            // runSpringComplete = true;
            if (status == AnimationStatus.completed) {
              runAnimationSpring = false;

              // if (_animationSpring != null && _animationSpring.value >= 2) {
              //   tasks.insert(
              //       index,
              //       Task(
              //           name: "new value " + index.toString(),
              //           color: ipColor.transform(index.toDouble())));
              // }
              // print(
              //     "_animationSpring?.value  " + _animationSpring?.value.toString());
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

  void setUpColorTasks() {
    for (int i = 0; i < tasks.length; i++) {
      tasks[i].color = ipColor.transform(i.toDouble());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerSpring?.dispose();
    _scrollController?.dispose();
    _timer.cancel();
    super.dispose();
  }

  AppBar appBar = AppBar(
    title: Text('Personal List'),
  );

  onScaleStart(ScaleStartDetails scaleStart) {
    if (scaleStart.pointerCount == 2) {
      this.setState(() {
        isRunningScale = true;
        focalY = scaleStart.localFocalPoint.dy;
      });
    }
  }

  onScaleUpdate(ScaleUpdateDetails scaleUpdate) {
    if (isRunningScale == true && scaleUpdate.pointerCount == 2) {
      this.setState(() {
        scaleRaw = scaleUpdate.scale;
        scale = scaleRaw;
      });
    }
  }

  onScaleEnd(ScaleEndDetails scaleEnd) {
    if (isRunningScale == true) {
      isRunningScale = false;
      runAnimationSpring = true;
      _animationSpring =
          _controllerSpring?.drive(Tween(begin: scaleRaw, end: 0));
      AnimatedHelper.runAnimateSpring(
        begin: scaleRaw,
        end: 0,
        controllerSpring: _controllerSpring,
      );
      // if (scaleRaw <= 2) {
      //   runAnimationSpring = true;
      //   _animationSpring =
      //       _controllerSpring?.drive(Tween(begin: scaleRaw, end: 0));
      //   AnimatedHelper.runAnimateSpring(
      //     begin: scaleRaw,
      //     end: 0,
      //     controllerSpring: _controllerSpring,
      //   );
      // } else {
      //   runAnimationSpring = true;
      //   _animationSpring =
      //       _controllerSpring?.drive(Tween(begin: scaleRaw, end: 2));
      //   AnimatedHelper.runAnimateSpring(
      //     begin: scaleRaw,
      //     end: 0,
      //     controllerSpring: _controllerSpring,
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // cel>= round>= floor
    int indexFirstItemCell = (scrollPosition / TASK_HEIGHT).ceil();
    int indexFirstItemFloor = (scrollPosition / TASK_HEIGHT).floor();
    int indexFirstItemWhenScroll = (scrollPosition / TASK_HEIGHT).round();

    indexNewTask = ((focalY / TASK_HEIGHT).round());
    index = indexNewTask + indexFirstItemWhenScroll;
    double translateY = indexNewTask * TASK_HEIGHT - (TASK_HEIGHT / 2);
    if (scrollPosition != 0) {
      if (indexFirstItemWhenScroll == indexFirstItemCell) {
        translateY = translateY - (scrollPosition % TASK_HEIGHT - TASK_HEIGHT);
      } else if (indexFirstItemWhenScroll == indexFirstItemFloor) {
        translateY = translateY - (scrollPosition % TASK_HEIGHT);
      }
    }

    // Offset global=Offset(0, 0);
    // Offset localStack=Offset(0, 0);
    // if(keyListView.currentContext!=null && keyStack.currentContext!=null)
    //   {
    //     RenderBox renderListView = keyListView.currentContext.findRenderObject();
    //     RenderBox renderStack = keyStack.currentContext.findRenderObject();
    //
    //     Offset offsetScroll=Offset(0, index*TASK_HEIGHT);
    //      global= renderListView.localToGlobal(offsetScroll);
    //       localStack=renderStack.globalToLocal(global);
    //     print("localStack "+ localStack.toString());
    //   }
    //
    //
    // print("size "+size.height.toString());
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: RawGestureDetector(
          behavior: HitTestBehavior.translucent,
          gestures: {
            AllowMultipleScaleRecognizer: GestureRecognizerFactoryWithHandlers<
                AllowMultipleScaleRecognizer>(
              () => AllowMultipleScaleRecognizer(), //constructor
              (AllowMultipleScaleRecognizer instance) {
                //initializer
                instance.onStart = (details) => this.onScaleStart(details);
                instance.onEnd = (details) => this.onScaleEnd(details);
                instance.onUpdate = (details) => this.onScaleUpdate(details);
              },
            ),

          },
          child: Stack(

            children: [
              NewTask(
                translationY: translateY,
                scale: scale,
                task: Task(name: "New Task ", color: Colors.blue),
              ),
              SingleChildScrollView(

                controller: _scrollController,
                physics: isRunningScale == true
                    ? NeverScrollableScrollPhysics()
                    : ClampingScrollPhysics(),
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
    double scaleFactor = scale * (TASK_HEIGHT / 4);
    List<Widget> results = [];
    for (int i = 0; i < tasks.length; i++) {
      bool isOnTop = i < index;
      double translateY = scaleFactor * (isOnTop == true ? -1 : 1);

      // print("======================>");
      // print("i "+i.toString());

      // print("<======================");
      results.add(Transform.translate(
        offset: Offset(0, translateY),
        child: TaskView(
          task: tasks[i],
        ),
      ));
    }
    return results;
  }
}
