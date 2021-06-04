import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mood_detectionapp/Dashboard.dart';
import 'package:mood_detectionapp/user.dart';

import 'loginscreen.dart';
import 'signupscreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class _HomePageState extends State<HomePage> {
  bool loading = false;
  // COLORS ARE TENTATIVE NEED TO UPDATE ----------------------------------------
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<Timer> loadData() async {
    return Timer(Duration(seconds: 3), navigatePage);
  }

  void navigatePage() {
    FirebaseAuth.instance.currentUser().then((val) {
      if (val != null) {
        print('\n\n in Splash ${val.email}\n\n');
        Firestore.instance
            .collection('Users')
            .document(val.email)
            .get()
            .then((d) {
          if (d.data != null) {
            User.userData.userEmail = d.data['user_email'];
            User.userData.userName = d.data['user_name'];
          } else {
            print('new user');
          }
        }).then((g) {
          Get.offAll(Dashboard(), transition: Transition.fadeIn);
        }).catchError((e) {
          print('new user');
        });
      } else {
        print('new user');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: Container(
        //height: 500,
        //color:Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 35),
        padding: EdgeInsets.only(left: 0, top: 60, right: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //We take the image from the assets
            SizedBox(height: 10),
            Image.asset(
              'assets/splash-img.png',
              //fit: BoxFit.contain,
              //height: 150,
            ),
            SizedBox(
              height: 10,
            ),
            //Texts and Styling of them
            Text(
              'Welcome!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Mood Detection Based Music Player',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              height: 30,
            ),
            //Our MaterialButton which when pressed will take us to a new screen named as
            //LoginScreen
            MaterialButton(
              elevation: 0,
              height: 50,
              //color: logoGreen,
              padding: EdgeInsets.only(left: 0, top: 25, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                      padding: EdgeInsets.only(left: 18, right: 18),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white),
                  SizedBox(width: 20.0),
                  RaisedButton(
                      padding: EdgeInsets.only(left: 18, right: 18),
                      onPressed: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()));
                      },
                      child: Text(
                        'REGISTER',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.white),
                ],
              ),
            ),
            SizedBox(height: 20),
            SignInButton(Buttons.Google, text: "Login with Google",
                onPressed: () async {
              initiateGoogleLogin();
            }),
          ],
        ),
      ),
    );
  }

  Future<void> initiateGoogleLogin() async {
// return Get.to(SignInDemo());
    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    try {
/* User user =*/ await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) {
        Get.offAll(Dashboard());
        print(value.user.email);
      }).catchError((g) {
        String error = g.toString();
        if (error.contains('ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL')) {
          Fluttertoast.showToast(
            msg: 'Email already exist',
          );
        } else {
          Fluttertoast.showToast(
            msg: g.toString(),
          );
        }
      });
    } catch (e) {
      print(e.toString());
      GoogleSignIn().signOut();
    }
    return '';
  }

  void getDataFromDB(FirebaseUser user, String email) {
    Firestore.instance
        .collection('Users')
        .document(email ?? user.email)
        .get()
        .then((d) {
      if (d.data != null) {
        User.userData.userEmail = d.data['user_email'];
        User.userData.userName = d.data['user_name'];
      } else {
        Fluttertoast.showToast(
          msg: "Please SignUp First",
        );
        FirebaseAuth.instance.signOut();
        GoogleSignIn gSignIn = GoogleSignIn();
        gSignIn.signOut();
      }
    }).then((g) {
      Get.offAll(Dashboard(), transition: Transition.fadeIn);
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    });
  }
}

// _signInwithGoogle() async {
//   final GoogleSignInAccount googleUser = await googleSignIn.signIn();
//   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//   final AuthCredential credential = GoogleAuthProvider.getCredential(
//       idToken: googleAuth.idToken,
//       accessToken: googleAuth
//           .accessToken); //is me google se id and access token k help se singin authenticate kia jaraha after that login hoga.
//   //signin will work now
//   final FirebaseUser user =
//       (await firebaseAuth.signInWithCredential(credential)).user;
// }
