import 'package:firebase_auth/firebase_auth.dart';

class AppUser{
  static User data = FirebaseAuth.instance.currentUser;
}

List<String> allCategories = ["Anger", "Neutral", "Fear", "Happy", "Sad"];
