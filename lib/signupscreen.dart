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
import 'package:mooddetection/loginscreen.dart';
import 'package:mooddetection/user.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Color primaryColor = Color(0xff18203d);
  Color secondaryColor = Color(0xff232c51);
  Color logoGreen = Color(0xff25bcbb);

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool loading = false;
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  Map<String, String> _authData = {'email': '', 'password': ''};
  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured'),
              content: Text(msg),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

/*  Future<void> _submit() async
  {
    if(!_formKey.currentState.validate())
    {
      return;
    }
    _formKey.currentState.save();

    try{
      await Provider.of<Authentication>(context, listen: false).signUp(
          _authData['email'],
          _authData['password']
      );
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);

    } catch(error)
    {
      var errorMessage = 'Authentication Failed. Please try again later.';
      _showErrorDialog(errorMessage);
    }

  }
  }*/
  @override
  Widget build(BuildContext context) {
    return /*MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Authentication(),
        )
      ],
      child:*/
        ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        backgroundColor: Colors.red[900],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 45),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Register to Continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Enter your email and password to login!',
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.openSans(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: userNameCont,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.yellow),
                      fillColor: Colors.white,
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.white),
                      focusColor: Colors.white,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter UserName';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: emailCont,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(color: Colors.yellow),
                      fillColor: Colors.white,
                      labelText: 'Email',
                      focusColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.white),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                  TextFormField(
                    // PASSWORD
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: passwordCont,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      focusColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.yellow),
                      labelStyle: TextStyle(color: Colors.white),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value.length <= 5) {
                        return 'Password length must me 6+ Charcters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  TextFormField(
                    // CONFIRM PASSWORD
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.yellow),
                      labelStyle: TextStyle(color: Colors.white),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty || value != passwordCont.text) {
                        return 'Passwords do no match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    elevation: 0,
                    minWidth: double.maxFinite,
                    height: 40,
                    onPressed: () {
                      emailSignUp();
                    },
                    color: Colors.white,
                    child: Text('Register',
                        style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 50),
                  _buildFooterLogo(),
                  // Container(
                  //   // height: 200,
                  //   child: Align(
                  //     alignment: Alignment.bottomRight,
                  //     child: MaterialButton(
                  //       elevation: 0,
                  //       minWidth: 10,
                  //       height: 10,
                  //       onPressed: () {
                  //         Navigator.push(context,
                  //             MaterialPageRoute(builder: (_) => Dashboard()));
                  //       },
                  //       color: Colors.white,
                  //       child: Text('Next',
                  //           style: TextStyle(
                  //               color: Colors.red[900],
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.bold)),
                  //       textColor: Colors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),

//      ),
      ),
      progressIndicator: SpinKitWave(
        color: Colors.red[900],
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

  buildTextField(String labelText, IconData icon) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red[900], border: Border.all(color: Colors.blue)),
      // Above BORDER LINES IN EMAIL AND PASS
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }

  void emailSignUp() {
    setState(() {
      loading = true;
    });
    if (_formKey.currentState.validate()) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailCont.text, password: passwordCont.text)
          .then((f) {
        createUserDatabase(f.user, userNameCont.text);
      }).catchError((e) {
        String error = e.toString();
        setState(() {
          loading = false;
        });
        if (error.contains('ERROR_EMAIL_ALREADY_IN_USE')) {
          Fluttertoast.showToast(
            msg: "Email already in use",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.yellow,
          );
        } else {
          Fluttertoast.showToast(
            msg: "something went wrong",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.yellow,
          );
        }
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  void createUserDatabase(User user, String username) async {
    FirebaseFirestore.instance.collection('Users').doc(emailCont.text).set({
      'created_at': Timestamp.now(),
      'user_name': userNameCont.text,
      'user_email': emailCont.text,
    }).then((f) async {
      setState(() {
        loading = false;
        emailCont.clear();
        passwordCont.clear();
        userNameCont.clear();
      });
      Get.offAll(LoginScreen());
      Fluttertoast.showToast(
        msg: "SignUp Successful",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.yellow,
      );
    }).catchError((e) {
      setState(() {
        loading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
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
