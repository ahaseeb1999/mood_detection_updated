import 'package:cloud_firestore/cloud_firestore.dart';

class AudioFile {
  String fileUrl;
  String fileName;
  Timestamp addedAt;
  String addedBy;
  String category;

  AudioFile(
      {this.fileUrl, this.fileName, this.addedAt, this.addedBy, this.category});

  AudioFile.fromJson(dynamic json) {
    fileUrl = json["file_url"];
    fileName = json["file_name"];
    addedAt = json["added_at"];
    addedBy = json["added_by"];
    category = json["category"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["file_url"] = fileUrl;
    map["file_name"] = fileName;
    map["added_at"] = addedAt;
    map["added_by"] = addedBy;
    map["category"] = category;
    return map;
  }
}
