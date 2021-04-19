import 'dart:async';

import 'package:clear_todo/helper/animated_helper.dart';
import 'package:clear_todo/helper/animated_interpolation.dart';
import 'package:clear_todo/models/task.dart';
import 'package:clear_todo/pages/new_task.dart';
import 'package:clear_todo/pages/new_task_overscroll.dart';
import 'package:clear_todo/pages/task_view.dart';
import 'package:clear_todo/helper/allow_multiple_scale_recognizer.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:flutter/physics.dart';
import 'dart:math' as math;

import 'flutter_reorderable_list.dart';

const double TASK_HEIGHT = 64;

enum STATE_ANIMATION {
  NONE,
  FLIP,
  OVER_SCROLL,
  RE_ORDER,
}

class PersonalListPage extends StatefulWidget {
  @override
  _PersonalListPageState createState() => _PersonalListPageState();
}

class _PersonalListPageState extends State<PersonalListPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController;
  double scrollPosition = 0;
  double overScroll = 0;
  AnimationController _controllerScaleEnd;
  Animation<double> _animationScaleEnd;

  AnimationController _controllerOverScrollEnd;
  Animation<double> _animationOverScrollEnd;
  STATE_ANIMATION stateAnimation = STATE_ANIMATION.NONE;

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

    initData();

    initInterpolation();
    initAnimationSpring();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    setUpColorTasks();
  }

  initData() {
    for (int i = 0; i < tasks.length; i++) {
      tasks[i].key = Key(i.toString());
    }
  }

  void initAnimationSpring() {
    _controllerScaleEnd =
        AnimationController(vsync: this, lowerBound: -500, upperBound: 500)
          ..addListener(() {
            if (runAnimationSpring == true) {
              setState(() {
                scale = _animationScaleEnd?.value;
              });
            }
          })
          ..addStatusListener((AnimationStatus status) {
            // runSpringComplete = true;
            if (status == AnimationStatus.completed) {
              runAnimationSpring = false;
            }
          });

    _controllerOverScrollEnd =
        AnimationController(vsync: this, lowerBound: -500, upperBound: 500)
          ..addListener(() {
            setState(() {
              overScroll = _animationOverScrollEnd?.value;
            });
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
    _controllerScaleEnd?.dispose();
    _controllerOverScrollEnd?.dispose();
    _scrollController?.dispose();
    _timer.cancel();
    super.dispose();
  }

  AppBar appBar = AppBar(
    title: Text('Personal List'),
  );

  int pointerCount=0;
  onScaleStart(ScaleStartDetails scaleStart) {

    if (scaleStart.pointerCount == 2) {
      this.setState(() {
        pointerCount=scaleStart.pointerCount;
        isRunningScale = true;
        stateAnimation = STATE_ANIMATION.FLIP;
        focalY = scaleStart.localFocalPoint.dy;
      });
    }
   else
     {
       pointerCount=scaleStart.pointerCount;
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
    setState(() {
      pointerCount=0;
    });

    if (isRunningScale == true) {
      isRunningScale = false;
      runAnimationSpring = true;
      _animationScaleEnd =
          _controllerScaleEnd?.drive(Tween(begin: scaleRaw, end: 0));
      AnimatedHelper.runAnimateSpring(
          begin: scaleRaw,
          end: 0,
          controllerSpring: _controllerScaleEnd,
          whenCompleteOrCancel: () {
            stateAnimation = STATE_ANIMATION.NONE;
          });
    }
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
    } else if (notification is ScrollEndNotification) {
      if (scrollPosition <= TASK_HEIGHT) {
        _animationOverScrollEnd =
            _controllerOverScrollEnd?.drive(Tween(begin: overScroll, end: 0));
        AnimatedHelper.runAnimateSpring(
            begin: overScroll,
            end: 0,
            controllerSpring: _controllerOverScrollEnd,
            whenCompleteOrCancel: () {
              stateAnimation = STATE_ANIMATION.NONE;
            });
      }
      else
        {
          stateAnimation = STATE_ANIMATION.NONE;
        }
    } else if (notification is ScrollUpdateNotification) {
      setState(() {
        scrollPosition = notification.metrics.pixels;

      });
    } else if (notification is OverscrollNotification) {
      setState(() {
        stateAnimation = STATE_ANIMATION.OVER_SCROLL;
        overScroll =
            (overScroll + notification.overscroll / 2).clamp(-TASK_HEIGHT, 0.0);
      });
    }
    return false;
  }

  // REORDER
  int _indexOfKey(Key key) {
    return tasks.indexWhere((Task d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);
    Task draggedItem = tasks[draggingIndex];
    setState(() {
      debugPrint("Reordering $item -> $newPosition");
      tasks.removeAt(draggingIndex);
      tasks.insert(newPositionIndex, draggedItem);
    });
    return true;
  }

  void _reorderDone(Key item) {
    final Task draggedItem = tasks[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.name}}");
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // FLIP

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

    // overScroll to create new task

    double positionOverScroll =
        (-overScroll - scrollPosition).clamp(0.0, TASK_HEIGHT);
    double translationOverScroll = -TASK_HEIGHT;
    translationOverScroll = InterpolationTween(
            inputRange: [0, TASK_HEIGHT],
            outputRange: [-TASK_HEIGHT, 0],
            extrapolate: ExtrapolateType.clamp)
        .transform(positionOverScroll);
    double rotationX = InterpolationTween(
            inputRange: [0, TASK_HEIGHT],
            outputRange: [-math.pi / 2, 0],
            extrapolate: ExtrapolateType.clamp)
        .transform(positionOverScroll);
    return Scaffold(
      appBar: appBar,
      body: RawGestureDetector(
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
            NewTaskOverScroll(
              translateY: translationOverScroll,
              rotateX: rotationX,
            ),
            NotificationListener(
              onNotification: onNotification,
              child: ReorderableList(
                onReorder: this._reorderCallback,
                onReorderDone: this._reorderDone,
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: listTasks(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> listTasks() {
    double translateY = 0;

    List<Widget> results = [];

    for (int i = 0; i < tasks.length; i++) {
      if (stateAnimation == STATE_ANIMATION.FLIP) {
        print("STATE_ANIMATION.FLIP");
        final double scaleFactor = scale * (TASK_HEIGHT / 4);
        bool isOnTop = i < index;
        translateY = scaleFactor * (isOnTop == true ? -1 : 1);
      } else if (stateAnimation == STATE_ANIMATION.OVER_SCROLL) {
        translateY = -overScroll;
      }

      results.add(Transform.translate(
        offset: Offset(0, translateY),
        child: ReorderableItem(
            key: tasks[i].key,
            childBuilder: (BuildContext context, ReorderableItemState state) {
              return DelayedReorderableListener(
                canStart: (){
                  print("pointerCount "+pointerCount.toString());
                  if(stateAnimation==STATE_ANIMATION.NONE && pointerCount<2)
                    {
                      return true;
                    }
                  return false;
                },
                child: Opacity(
                  opacity:
                      state == ReorderableItemState.placeholder ? 0.0 : 1.0,
                  child: TaskView(
                    key: tasks[i].key,
                    task: tasks[i],
                  ),
                ),
              );
            }),
      ));
    }
    return results;
  }
}
