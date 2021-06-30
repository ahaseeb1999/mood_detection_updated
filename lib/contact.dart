import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context,
      //           MaterialPageRoute(builder: (_) => DashBoardHomePage()));
      //     },
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //   ),
      //   title: Text('Contact'),
      // ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 40.0,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text('FYP-Maju Team'.toUpperCase()),
            SizedBox(
              height: 15.0,
              width: 200.0,
              child: Divider(
                color: Colors.pink,
              ),
            ),
            Text('Andriod Developer'.toUpperCase()),
            SizedBox(
              height: 10.0,
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                leading: Icon(
                  Icons.phone,
                  color: Colors.pink,
                ),
                title: Text('9200000019'),
              ),
            ),
            Card(
              margin: EdgeInsets.all(10.0),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.pink,
                ),
                title: Text('fa17fyp2020@gmail.com'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
