import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  LoadingScreen({this.message});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/gifs/loader_anim.gif",
          height: Get.height * 0.5,
        ),
        Center(
          child: new Text(message ?? "Uploading Music",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                letterSpacing: -0.28,
              )),
        )
      ],
    );
  }
}
