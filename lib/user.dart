import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  // singleton
  static final UserData _singleton = UserData._internal();

  factory UserData() => _singleton;

  UserData._internal();

  static UserData get userData => _singleton;
  User user;

  String userEmail = '';
  String userName = '';
}
