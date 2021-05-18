import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtil {
  static createFolder(String filepath) async {
    var file = Directory(filepath);
    try {
      bool exists = await file.exists();
      if (!exists) {
        await file.create();
      }
    }catch (e) {
      print(e);
    }
  }

  static Future<File> createFile(String path,String fileName) async {
    final filePath = path + '/' + fileName;
    return new File(filePath);
  }

  static Future<String> getFileSavePath() async {
    return (await getExternalStorageDirectory()).path;
  }
}