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

  Future<bool> onWillPop() {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          // all of the main screens in the dashboard will use the same appbar, no need to code appbar in new pages
          backgroundColor: Colors.red[900],
          title: Text(_currentIndex == 0
              ? 'Dashboard'
              : _currentIndex == 1
                  ? 'Profile'
                  : 'Contact'),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), title: Text("Profile")),
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_page), title: Text("Contact")),
            BottomNavigationBarItem(
                icon: Icon(Icons.logout), title: Text("Logout")),
          ],
        ),
        body: getBodyWidget(),
      ),
    );
  }

  getBodyWidget() {
    // page navigation, add your pages here according to index

    // return (_currentIndex == 0) ? DashBoardHomePage() : Container();
    switch (_currentIndex) {
      case 0:
        return DashBoardHomePage();
        break;
      case 1:
        return DashBoardHomePage(); // replace it with profile page when completed
        break;
      case 2:
        return Contact();
        break;
      // case 3:return DashBoardHomePage();break;
    }
  }
}
