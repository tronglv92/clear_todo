import 'dart:collection';

import 'package:clear_todo/helper/animated_interpolation.dart';
import 'package:clear_todo/models/task.dart';
import 'package:flutter/material.dart';

import 'item_reorder_stack.dart';

class TestReorderPage extends StatefulWidget {
  @override
  _TestReorderPageState createState() => _TestReorderPageState();
}

class _TestReorderPageState extends State<TestReorderPage> {


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
  ];

  final HashMap<int, _ItemReorderState> _items =
  new HashMap<int, _ItemReorderState>();

  void registerItem(_ItemReorderState item,int index) {
    _items[index] = item;
  }

  void unregisterItem(int index) {
     _items.remove(index);
  }


  double dragPosition=0;
  bool isDrag=false;
  int indexDrag=-1;

  int indexFrom=-1;
  int indexTo=-1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  void move(int from,int to)
  {
    _items[from].moveTo(to);
    _items[to].moveTo(from);
    indexFrom=indexTo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onLongPressStart: (LongPressStartDetails startDetails)
          {
            setState(() {
              isDrag=true;
              indexDrag=(startDetails.localPosition.dy/HEIGHT_ITEM).floor();
              indexFrom=indexDrag;
              dragPosition=indexDrag*HEIGHT_ITEM;
            });

          },
          onLongPressMoveUpdate: (LongPressMoveUpdateDetails updateDetails)
          {

            setState(() {

              dragPosition=(indexDrag*HEIGHT_ITEM)+ updateDetails.localOffsetFromOrigin.dy;
              indexTo=(dragPosition/HEIGHT_ITEM).floor();
              if(indexTo!=indexFrom)
                {
                  move(indexFrom, indexTo);


                }

            });

            // setState(() {
            //
            //   dragPosition=updateDetails.localOffsetFromOrigin.dy;
            // });
          },

          onLongPressEnd: (LongPressEndDetails endDetails){
            setState(() {
              isDrag=false;
              indexDrag=-1;
            });
          },
          child: Stack(
            children: [
              ListView(
                children: [
                  for (int i = 0; i < tasks.length; i++)
                    ItemReorder(task: tasks[i],index: i,key: Key(i.toString()),)
                ],
              ),
              isDrag==true? Positioned(
                  top: dragPosition,
                  height: HEIGHT_ITEM,
                  width: MediaQuery.of(context).size.width,
                  child: ItemReorderStack()):Container(),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _items[4].moveTo(3);
          _items[3].moveTo(4);
        },
        child: Center(
          child: Text(
            "ADD",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
  static _TestReorderPageState of(BuildContext context) {
    return context.findAncestorStateOfType<_TestReorderPageState>();
  }
}
const double HEIGHT_ITEM=100;
class ItemReorder extends StatefulWidget {
  final Task task;
  final int index;

  ItemReorder({this.task,this.index, Key key}):super(key:key );

  @override
  _ItemReorderState createState() => _ItemReorderState();
}

class _ItemReorderState extends State<ItemReorder> with TickerProviderStateMixin{
  get key => widget.key;
  AnimationController controller;
  Animation<double> translationY;
  Animation<double> curve;

  _TestReorderPageState _listState;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initAnimation();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller?.dispose();
    super.dispose();
  }
  @override
  deactivate()
  {
    _listState?.unregisterItem(widget.index);
    _listState = null;

    super.deactivate();
  }
  void update() {
    if (mounted) {
      setState(() {});
    }
  }
  initAnimation(){
    controller=AnimationController(vsync: this,duration: Duration(milliseconds: 1000))..addListener(() {
      setState(() {

      });
    });
    curve =
        CurvedAnimation(parent: controller, curve: Curves.linear);
    translationY = Tween<double>(begin: 0, end: -HEIGHT_ITEM).animate(curve);

  }


  moveTo(int index)
  {

    int diff=index-widget.index;
    translationY = Tween<double>(begin: 0, end: diff*HEIGHT_ITEM).animate(curve);
    controller.reset();
    controller.stop(canceled: true);
    controller.forward();

  }
  @override
  Widget build(BuildContext context) {
    _listState = _TestReorderPageState.of(context);

    _listState.registerItem(this,widget.index);

    Color color=ColorInterpolationTween(inputRange: [
      0,
      10
    ], outputRange: [
      Color.fromRGBO(197, 43, 39, 1.0),
      Color.fromRGBO(225, 176, 68, 1.0)
    ], extrapolate: ExtrapolateType.clamp).transform(widget.index.toDouble());


    return  Transform.translate(
      offset: Offset(0,translationY.value),
      child: Container(
        height: HEIGHT_ITEM,
        color: color,
        child: Center(
          child: Text(
            widget.task.name,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
