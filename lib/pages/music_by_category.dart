import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_detectionapp/models/audio.dart';
import 'package:mood_detectionapp/utils/global.dart';

class MusicByCategory extends StatefulWidget {
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
            .orderBy("category")
            .orderBy("added_at")
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
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
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        a.fileName,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      a.addedAt.toDate() ?? "",
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
