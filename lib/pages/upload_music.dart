import 'package:flutter/material.dart';

class UploadMusic extends StatefulWidget {
  @override
  _UploadMusicState createState() => _UploadMusicState();
}

class _UploadMusicState extends State<UploadMusic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text('Upload Music'),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          "n",
          style: TextStyle(color: Colors.red[900], fontSize: 28),
        ),
      ),
    );
  }
}
