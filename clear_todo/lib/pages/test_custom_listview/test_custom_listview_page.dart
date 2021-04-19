import 'package:clear_todo/pages/test_custom_listview/my_listview.dart';
import 'package:flutter/material.dart';
class TestCustomListViewPage extends StatefulWidget {
  @override
  _TestCustomListViewPageState createState() => _TestCustomListViewPageState();
}

class _TestCustomListViewPageState extends State<TestCustomListViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: MyListView(

      ),
    );
  }
}
