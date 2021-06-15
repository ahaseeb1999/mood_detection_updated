import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mooddetection/HomePage.dart';

class LogoutDialog extends StatefulWidget {
  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * .24,
          width: MediaQuery.of(context).size.width * .8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Are you sure?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.height * .0225,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "You want to logout.",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: MediaQuery.of(context).size.height * .0225,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[_button(1), _button(2)],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _button(int id) {
    return GestureDetector(
      onTap: () {
        if (id == 1) {
          Get.back();
        } else {
          FirebaseAuth.instance.signOut();
          GoogleSignIn gSignIn = GoogleSignIn();
          gSignIn.signOut();
          Get.offAll(HomePage());
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * .05,
        width: MediaQuery.of(context).size.width * .3,
        decoration: BoxDecoration(
          color: id == 1 ? Color(0xff9a9a9a) : Colors.red[900],
          boxShadow: [
            BoxShadow(
              offset: Offset(0.00, 3.00),
              color: Color(0xff000000).withOpacity(0.16),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(4.00),
        ),
        child: Text(
          id == 1 ? "No" : "Yes",
          style: TextStyle(fontSize: MediaQuery.of(context).size.height * .02),
        ),
      ),
    );
  }
}
