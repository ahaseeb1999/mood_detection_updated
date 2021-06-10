import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerServices {
  Future<File> pickSingleFile() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.audio);

    if (result != null) {
      File file = File(result.files.single.path);
      return file;
    } else {
      return null;
    }
  }
}
