import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mooddetection/models/audio.dart';
import 'package:mooddetection/services/file_picker.dart';
import 'package:mooddetection/services/firestorage_service.dart';
import 'package:mooddetection/utils/global.dart';
import 'package:mooddetection/widgets/loader.dart';

class UploadMusic extends StatefulWidget {
  @override
  _UploadMusicState createState() => _UploadMusicState();
}

class _UploadMusicState extends State<UploadMusic> {
  File pickedFile;
  FilePickerServices _filePicker = FilePickerServices();
  FStorageServices _storageServices = FStorageServices();
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool isLoading = false;
  String seletedCat = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text('Upload Music'),
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: LoadingScreen(
                message: "Please wait while music is being uploaded",
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: picker(),
            ),
    );
  }

  Widget picker() {
    return Column(
      children: [
        Text("Select category below to upload music"),
        Expanded(
          child: Column(
            children: List.generate(allCategories.length, (index) {
              return ListTile(
                title: Text(allCategories[index]),
                onTap: () {
                  seletedCat = allCategories[index];
                  onUploadTapped();
                },
              );
            }),
          ),
        )
      ],
    );
  }

  //functions
  onUploadTapped() async {
    File file = await _filePicker.pickSingleFile();
    if (file != null) {
      try {
        setState(() {
          isLoading = true;
        });
        Get.snackbar("Uploading...", "Your file is being uploaded...",
            showProgressIndicator: true, duration: Duration(seconds: 3));
        String url = await _storageServices.uploadSingleFile(
            bucketName: 'audios', userEmail: AppUser.data.email, file: file);
        setState(() {
          isLoading = false;
        });
        if (url != null) {
          AudioFile audio = AudioFile(
              fileUrl: url,
              fileName: file.path.split("/").last,
              addedBy: AppUser.data.email,
              addedAt: Timestamp.now(),
              category: seletedCat);
          setState(() {
            isLoading = true;
          });
          String docId = Timestamp.now()
              .millisecondsSinceEpoch
              .toString(); // to make every document unique
          db.collection("audios").doc(docId).set(audio.toJson());
          setState(() {
            isLoading = false;
            pickedFile = null;
          });
          Fluttertoast.showToast(msg: "Song uploaded successfully");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Failed to upload");
      }
    }
  }
}
