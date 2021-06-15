import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'notification.dart';

class choose_mood extends StatefulWidget {
  final String title;

  const choose_mood({
    @required this.title,
  });

  @override
  _choose_moodState createState() => _choose_moodState();
}

class _choose_moodState extends State<choose_mood> {

  final notifications = [
    NotificationSetting(title: 'Happy'),
    NotificationSetting(title: 'Sad'),
    NotificationSetting(title: 'Anger'),
    NotificationSetting(title: 'Neutral'),
    NotificationSetting(title: 'Fear'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text("Choose Your Mood"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, top: 100, right: 0),
        child: ListView(
          children: [
            ...notifications.map(buildSingleCheckbox).toList(),
          ],
        ),
      ),
    );
  }
  Widget buildSingleCheckbox(NotificationSetting notification) => buildCheckbox(
    notification: notification,
    onClicked: () {
      setState(() {
        final newValue = !notification.value;
        notification.value = newValue;

      });
    },
  );

  Widget buildCheckbox({
    @required NotificationSetting notification,
    @required VoidCallback onClicked,
  }) =>
      ListTile(
        onTap: onClicked,
        leading: Checkbox(
          value: notification.value,
          onChanged: (value) => onClicked(),
        ),
        title: Text(
          notification.title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
}

