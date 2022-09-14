import 'dart:async';

import 'package:file_picker/file_picker.dart';

import 'package:get/get.dart';
import '../file_folder/store_screen.dart';
class FilePickers {
  PlatformFile file;
  void PickFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: [
      'pdf'
    ]);
    if (result != null) {
      PlatformFile file = result.files.first;
      Timer(Duration(seconds: 1), () {
        Get.offNamed('second', arguments: '${file.path}');
        save(file.path); });
    }
  }
}
