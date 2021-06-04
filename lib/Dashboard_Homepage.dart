import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mood_detectionapp/categories.dart';
import 'package:mood_detectionapp/choose_mood.dart';
import 'Emotion_detection.dart';
/*
import 'main.dart';
*/
import 'play_music.dart';

class DashBoardHomePage extends StatefulWidget {
  @override
  _DashBoardHomePageState createState() => _DashBoardHomePageState();
}

class _DashBoardHomePageState extends State<DashBoardHomePage> {
  var services = [
    "Scan Face",
    "Add image from Gallery",
    "Categories",
    "Upload Music",
    "Play Music",
    "Choose Mood Manually",
  ];

  var assets = [
    "assets/face-scan.png",
    "assets/add_image.png",
    "assets/music_icon.png",
    "assets/music-upload.png",
    "assets/play.png",
    "assets/choose_mood.png",
  ];
  File _image;
  File _image2;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future scanFace() async {
    final pickedFile2 = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image2 = File(pickedFile2.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: GridView.builder(
            itemCount: services.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 2)),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  index == 0
                      ? Get.to(Emotion_detection())
                      : index == 1
                      ? getImage()
                      : Get.to(Categories(
                    title: index == 2
                        ? "Categories"
                        : index == 3
                        ? "Upload Music"
                        : index == 4
                        ? Get.to(play_music())
                        : Get.to(choose_mood()),
                  ));
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        (index == 1 && _image != null)
                            ? Stack(
                          children: [
                            Container(
                              height: Get.height * .18,
                              width: Get.height * .18,
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red[900],
                                    ),
                                  ),
                                ))
                          ],
                        )
                            : (index == 0 && _image2 != null)
                            ? Stack(
                          children: [
                            Container(
                              height: Get.height * .18,
                              width: Get.height * .18,
                              child: Image.file(
                                _image2,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _image2 = null;
                                      });
                                    },
                                    child: Icon(
                                      Icons.cancel,
                                      color: Colors.red[900],
                                    ),
                                  ),
                                ))
                          ],
                        )
                            : Image.asset(
                          assets[index],
                          height: 50,
                          width: 50,
                        ),
                        (index == 1 && _image != null)
                            ? SizedBox()
                            : (index == 0 && _image2 != null)
                            ? SizedBox()
                            : Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              services[index],
                              style: TextStyle(
                                  fontSize: 16,
                                  height: 1.2,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}