import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mooddetection/models/audio.dart';
import 'package:mooddetection/play_music.dart';
import 'package:mooddetection/utils/global.dart';

class MusicByCategory extends StatefulWidget {
  final initialCat;
  MusicByCategory({this.initialCat});
  @override
  _MusicByCategoryState createState() => _MusicByCategoryState();
}

class _MusicByCategoryState extends State<MusicByCategory> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text('Categories'),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: db
            .collection("audios")
            .where("added_by", isEqualTo: AppUser.data.email)
            .where("category", isEqualTo: widget.initialCat)
            .orderBy("added_at")
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else if (snapshot.data.docs.isEmpty) {
            return Center(
              child: Text(
                  "No Music Found in ${widget.initialCat ?? "any"} category"),
            );
          } else {
            return ListView.separated(
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data.docs[index];
                  AudioFile audio = AudioFile.fromJson(doc.data());
                  return audioItem(audio);
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.docs.length);
          }
        },
      ),
    );
  }

  Widget audioItem(AudioFile a) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
      child: ListTile(
        isThreeLine: true,
        onTap: () => Get.to(MusicApp(
          url: a.fileUrl,
        )),
        leading: Icon(
          Icons.play_circle_outline,
          size: 48,
        ),
        title: Text(
          a.fileName,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            DateFormat("dd-mm-yyyy hh:mm a").format(a.addedAt.toDate()),
            style: TextStyle(fontSize: 10),
          ),
        ),
        trailing: Text(
          a.category ?? "",
        ),
      ),
    );
  }
}
