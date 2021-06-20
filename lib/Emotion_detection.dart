import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mooddetection/pages/music_by_category.dart';
import 'package:mooddetection/services/tflite_services.dart';

class Emotion_detection extends StatefulWidget {
  final ImageSource imageSource;
  Emotion_detection({@required this.imageSource});
  @override
  _Emotion_detectionState createState() => _Emotion_detectionState();
}

class _Emotion_detectionState extends State<Emotion_detection> {
  //tflite services
  TfLiteServices tfLite = TfLiteServices();
  // Variables
  bool _loading = true;
  // variable to store loaded image
  File _image;
  // variable to store tflite results
  String _output;
  // variable to load image
  final picker = ImagePicker();
  int padSize;
  ImageSource imgSource;

  onInit() async {
    await tfLite.loadModel();
    await Future.delayed(Duration(milliseconds: 20), () {
      imgSource = widget.imageSource;
      pickImage();
    });
  }

  @override
  void initState() {
    super.initState();
    onInit();
  }

  // Function to perform TFLite Inference
  classifyImage(File image) async {
    setState(() {
      _loading = true;
    });
    var output = await tfLite.runOnImage(image);
    setState(() {
      // set our global variable equal to local variable
      _output = output[0]['label'];
      _loading = false;
    });
    print("prediction: $_output");
  }

  // Function to dispose and clear mmemory once done inferring
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // helps avoid memory leaks
    tfLite.dispose();
  }

  // Function to pick image - using camera
  pickImage() async {
    // load image from source - camera/gallery
    var image = await picker.getImage(source: imgSource, imageQuality: 50);
    // check if error laoding image

    if (image == null) return Navigator.pop(context);
    setState(() {
      _image = File(image.path);
    });

    // classify image
    tfLite.loadModel();
    classifyImage(_image);
  }

  // Function to pick image - using gallery
  // pickGalleryImage() async {
  //   // load image from source - camera/gallery
  //   PickedFile image =
  //       await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
  //   // check if error laoding image
  //   if (image == null) return null;
  //   setState(() {
  //     _image = File(image.path);
  //     print(_image.path);
  //   });
  //
  //   // classify image
  //   classifyImage(_image);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      floatingActionButton: _output == null
          ? Container()
          : InkWell(
              onTap: () => Get.to(MusicByCategory(
                initialCat: _output,
              )),
              child: Card(
                elevation: 20,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                color: Colors.lightGreen,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_outlined),
                      Text("Play $_output music"),
                    ],
                  ),
                ),
              ),
            ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            // Center(
            //   child: Text(
            //     'TeachableMachines.com CNN',
            //     style: TextStyle(color: Color(0xFFEEDA28), fontSize: 18),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // SizedBox(
            //   height: 6,
            // ),
            Center(
              child: Text(
                'Detect Emotion',
                style: TextStyle(
                    color: Color(0xFFE99600),
                    fontWeight: FontWeight.w500,
                    fontSize: 28),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: _loading
                  ? Container(
                      width: 280,
                      child: Column(
                        children: [
                          /* _image != null
                              ? Image.file(_image)
                              :*/
                          Image.asset('assets/cat.jpg'),
                          SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          Container(
                            height: 250,
                            child: Image.file(_image),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _output != null
                              ? Text(
                                  'Predicted Label: $_output',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      imgSource = ImageSource.camera;
                      pickImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 150,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Take a Photo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      imgSource = ImageSource.gallery;
                      pickImage();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 150,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Camera Roll',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
