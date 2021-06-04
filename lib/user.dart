import 'package:firebase_auth/firebase_auth.dart';

class User {
  // singleton
  static final User _singleton = User._internal();

  factory User() => _singleton;

  User._internal();

  static User get userData => _singleton;
  FirebaseUser user;

  String userEmail = '';
  String userName = '';
}
