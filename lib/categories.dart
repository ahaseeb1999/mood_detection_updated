import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  String title;
  Categories({this.title});
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text('${widget.title}'),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          "${widget.title}"
          "",
          style: TextStyle(color: Colors.red[900], fontSize: 28),
        ),
      ),
    );
  }
}
