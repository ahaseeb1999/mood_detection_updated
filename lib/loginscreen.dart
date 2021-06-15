import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mooddetection/Dashboard.dart';
import 'package:mooddetection/user.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  TextEditingController emailTc = TextEditingController();
  GlobalKey<FormState> _signInKey = GlobalKey<FormState>();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  bool obsecurePass = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        backgroundColor: Colors.red[800],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 45),
            child: Form(
              key: _signInKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Login in App to continue',
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.openSans(color: Colors.white, fontSize: 28),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Enter your email and password to login!',
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.openSans(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(
                    height: 50,
                  ), //
                  buildTextField('Email', Icons.account_circle, emailCont,
                      1), // accounts_circle for Email
                  buildTextField('Password', Icons.lock, passwordCont,
                      2), //lock for Password
                  SizedBox(height: 30),
                  MaterialButton(
                    elevation: 0,
                    minWidth: double.maxFinite,
                    height: 50,
                    onPressed: () async {
                      if (_signInKey.currentState.validate()) {
                        emailSignIn();
                      }
                    },
                    color: Colors.white,
                    child: Text('Login',
                        style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    textColor: Colors.white,
                  ),
                  /*SizedBox(height: 20),
              //============= REGISTER
              MaterialButton(
                elevation: 0,
                minWidth: double.maxFinite,
                height: 50,
                onPressed: ()  async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SignupScreen()));
                },
                color: logoGreen,
                child: Text('Sign-Up',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),*/
                  //=========================
                  SizedBox(height: 60),
                  _buildFooterLogo()
                ],
              ),
            ),
          ),
        ),
      ),
      progressIndicator: SpinKitWave(
        color: Colors.white,
      ),
    );
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/logo.png',
          height: 40,
        ),
        Text('Mood Based Player',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  buildTextField(String labelText, IconData icon, controller, int id) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(color: Colors.red[900])),
      // Above BORDER LINES IN EMAIL AND PASS
      child: TextField(
        cursorColor: Colors.red,
        controller: controller,
        obscureText: id == 2 ? obsecurePass : false,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.red[900]),
            prefixIcon: Icon(
              icon,
              color: Colors.red[900],
            ),
            suffixIcon: id == 2
                ? IconButton(
                    onPressed: () =>
                        setState(() => obsecurePass = !obsecurePass),
                    icon: Icon(
                      obsecurePass
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.red[900],
                    ),
                  )
                : null,
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }

  void emailSignIn() {
    setState(() {
      loading = true;
    });
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailCont.text.replaceAll(' ', ''),
            password: passwordCont.text.replaceAll(' ', ''))
        .then((user) async {
      getDataFromDB(
        user.user,
        emailCont.text.replaceAll(' ', ''),
      );
    }).catchError((er) {
      String error = er.toString();
      setState(() {
        loading = false;
      });
      error.contains('WRONG_PASSWORD')
          ? Fluttertoast.showToast(msg: 'password is wrong')
          : error.contains('USER_NOT_FOUND')
              ? Fluttertoast.showToast(msg: 'Email not registered')
              : Fluttertoast.showToast(msg: 'Something went wrong');
    });
  }

  void getDataFromDB(User user, String email) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(email ?? user.email)
        .get()
        .then((d) {
      if (d.data != null) {
        UserData.userData.userEmail = d.data()['user_email'];
        UserData.userData.userName = d.data()['user_name'];
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
