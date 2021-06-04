import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mood_detectionapp/Emotion_detection.dart';

import 'HomePage.dart';
import 'Emotion_detection.dart';
//void main()=>runApp(MaterialApp(home: HomePage(),));
void main() => runApp(play_music());

class play_music extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
