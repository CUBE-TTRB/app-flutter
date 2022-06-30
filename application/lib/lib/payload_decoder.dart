import 'dart:convert';
import 'dart:io' as Io;
import 'dart:math';

import 'package:flutter/material.dart';

class Decoder{
  static String getPayload(String jwt) {
  var base64Url = jwt.split('.')[1];
  // var base64 = base64Url.replace('-', '+').replace('_', '/');
  return utf8.decode(base64.decode(base64Url));
  }

  static Io.File base64ToImage(String base64){
    Random random = Random();
    final decodedBytes = base64Decode(base64.split("base64,")[1]);
    var file = Io.File("${Io.Directory.systemTemp.path}/${random.nextInt(99999)}.png");
    file.writeAsBytesSync(decodedBytes);
    return file;
  }

  static String ImageToBase64(String path){
    List<int> imageBytes = Io.File(path).readAsBytesSync();
    return base64Encode(imageBytes);
  }
}

