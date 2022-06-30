import 'dart:convert';
import 'dart:developer' as developr;
import 'dart:io' as Io;
import 'dart:math';

import 'package:cube/model/comment_model.dart';

class ResourceModel{
  ResourceModel(this.id, this.type, this.title, this.body, this.date, this.categoryId, this.thumbnail, this.stringBody, this.visibility, this.commentCount, this.description, this.comments);
  final int id;
  final String type;
  final String title;
  final List<dynamic> body;
  final String stringBody;
  final String date;
  final int categoryId;
  final String? thumbnail;
  final String visibility;
  final String commentCount;
  final String? description;
  final List<dynamic> comments;

  ResourceModel.fromJson(dynamic json, String _commentCount)
      : id = json['id'],
        type = json['type'],
        title = json['title'],
        body = json['body'],
        stringBody =  json['body'].toString(),
        date = json['date'] ?? "",
        categoryId = json['categoryId'],
        thumbnail = json['thumbnail'],
        visibility = json['visibility'],
        commentCount = _commentCount,
        description = json['description'],
        comments = addAllComments(json['comments'])
  ;

  static List<CommentModel> addAllComments(commentList){
    List<CommentModel> result = [];
    for (int i = 0;i <commentList.length; i ++) {
      result.add(CommentModel.fromJson(commentList[i]));
    }
    return result;
  }



  String base64toTempFile(String base64){
    Random random = Random();
    final decodedBytes = base64Decode(base64);
    var file = Io.File("${Io.Directory.systemTemp.path}/${random.nextInt(99999)}.png");
    file.writeAsBytesSync(decodedBytes);
    return file.path;
  }
}