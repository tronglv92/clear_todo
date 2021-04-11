import 'package:clear_todo/pages/test/flip_widget.dart';
import 'package:flutter/material.dart';

class TestFlipPage extends StatefulWidget {
  @override
  _TestFlipPageState createState() => _TestFlipPageState();
}

class _TestFlipPageState extends State<TestFlipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(
          child: FlipWidget(child: Container(
            color: Colors.black,
            width: 100,
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Center(child: Text("2",style: TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.bold),)),
          ),),
        ),
    );
  }
}
