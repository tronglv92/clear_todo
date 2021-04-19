import 'package:clear_todo/helper/animated_interpolation.dart';
import 'package:clear_todo/models/task.dart';
import 'package:clear_todo/pages/test/test_page.dart';
import 'package:flutter/material.dart';

class ItemReorderStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: HEIGHT_ITEM,
      color: Colors.blue,
      child: Center(
        child: Text(
          "Test cho vui",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
