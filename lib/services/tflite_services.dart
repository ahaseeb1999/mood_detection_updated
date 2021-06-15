import 'dart:io';

import 'package:tflite/tflite.dart';

class TfLiteServices {
  // Function to Load Model
  Future<String> loadModel() async {
    // define model path and labels path
    String res = await Tflite.loadModel(
        model: 'assets/converted_model.tflite', labels: 'assets/label.txt');
    print(res);
    return res;
  }

  Future<List<dynamic>> runOnImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 20,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 1.0,
        asynch: true);
    print("Image pred = $output");
    return output;
  }

  void dispose() {
    Tflite.close();
  }
}
