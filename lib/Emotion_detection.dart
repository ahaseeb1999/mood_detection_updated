import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mood_detectionapp/services/tflite_services.dart';
import 'package:tflite/tflite.dart';

class Emotion_detection extends StatefulWidget {
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
  List _output;
  // variable to load image
  final picker = ImagePicker();
  int padSize;

  @override
  void initState() {
    super.initState();
    // load TFLite Model
    tfLite.loadModel();
  }

  // Function to perform TFLite Inference
  classifyImage(File image) async {
    setState(() {
      _loading = true;
    });
    var output = await tfLite.runOnImage(image);
    setState(() {
      // set our global variable equal to local variable
      _output = output;
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
    Tflite.close();
  }

  // Function to pick image - using camera
  pickImage() async {
    // load image from source - camera/gallery
    var image = await picker.getImage(source: ImageSource.camera);
    // check if error laoding image
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    // classify image
    classifyImage(_image);
  }

  // Function to pick image - using gallery
  pickGalleryImage() async {
    // load image from source - camera/gallery
    var image = await picker.getImage(source: ImageSource.gallery);
    // check if error laoding image
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    // classify image
    classifyImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
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
                                  'Predicted Label: ${_output[0]['label']}',
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
                    onTap: pickImage,
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
                    onTap: pickGalleryImage,
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
