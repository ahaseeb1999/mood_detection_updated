import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mooddetection/contact.dart';
import 'package:mooddetection/logout.dart';

import 'Dashboard_Homepage.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text(_currentIndex == 0
            ? 'Dashboard'
            : _currentIndex == 1
                ? 'Profile'
                : Get.to(contact())),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            index == 3 ? Get.dialog(LogoutDialog()) : _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box), title: Text("Profile")),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_page), title: Text("Contact")),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout), title: Text("Logout")),
        ],
      ),
      body: getBodyWidget(),
    );
  }

  getBodyWidget() {
    return (_currentIndex == 0) ? DashBoardHomePage() : Container();
  }
}
