import 'package:clear_todo/helper/animated_interpolation.dart';
import 'package:clear_todo/pages/test/test_page.dart';
import 'package:flutter/material.dart';

class ItemTest extends StatelessWidget {
  final int index;

  final double overScroll;

  ItemTest({this.index,this.overScroll,Key key}):super(key: key);
  @override
  Widget build(BuildContext context) {
    // double translationY=InterpolationTween(
    //     inputRange: [0, index * HEIGHT_ITEM],
    //     outputRange: [0, -index * HEIGHT_ITEM],
    //     extrapolateRight: ExtrapolateType.clamp).transform(y);

    double translationY=-overScroll;
    return Transform.translate(
      offset: Offset(0,translationY),
      child: Container(
        height: HEIGHT_ITEM,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          color: Colors.red,
        ),
        child: Center(
          child: Text(
              (index+1).toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
