import 'dart:convert';
import 'dart:developer';
import 'package:cube/api/connexion_data.dart';
import 'package:cube/elements/resource_element.dart';
import 'package:cube/model/comment_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../lib/payload_decoder.dart';
import '../model/resources_model.dart';

enum RequestType{
  get, post,delete,patch
}


class RequestResult<T>{
  RequestResult(this.result,this.validResult,this.errorResult);
  T result;
  bool validResult;
  String? errorResult;
}
class RequestApi {
  static const String baseUrl = "https://api-cube.remidurieu.dev/";

  static Future<RequestResult<dynamic>> request({ required String endPoint, required RequestType requestType, required dynamic body}) async {
    http.Response response;
    if(requestType == RequestType.post) {
      response = await http.post(Uri.parse( baseUrl+endPoint),
          headers: { "Content-Type": "application/json"},
          body: jsonEncode(body));
      response = await http.post(Uri.parse( baseUrl+endPoint),
          headers: { "Content-Type": "application/json"},
          body: jsonEncode(body));
      log("REQUEST : $endPoint type: $requestType body: $body RESPONSE : Code : ${response.statusCode} "); //resp : ${jsonEncode(response.body)}");
      if (response.statusCode >= 200 && response.statusCode < 400) {
        dynamic bodyresp = await response.body;

        return RequestResult<dynamic>(bodyresp, true, null);
      }
      else{
        return RequestResult<dynamic>("Error", false, response.statusCode.toString());
      }
    } else {
      Uri uri =  Uri.parse( baseUrl+endPoint);
      Uri newUri = uri.replace( queryParameters : body);
      final request = Request('GET', uri);
      request.body = jsonEncode(body);
      request.headers.addAll({"content-type": "application/json"});
      final response2 = await request.send();
      Response response3 = await http.Response.fromStream(response2);
      log("REQUEST : $endPoint type: $requestType body: $body RESPONSE : Code : ${response3.statusCode}"); // resp : ${jsonEncode(response3.body)}");

      if (response3.statusCode >= 200 && response3.statusCode < 400) {
        return RequestResult<dynamic>(response3.body, true, null);
      }
      else{
        return RequestResult<dynamic>("Error", false, response3.statusCode.toString());
      }
      // response = await http.get(newUri,
      //     headers: { "Content-Type": "application/json"},);

    }
  }
}


class RequestDictionary{
  static Future<String> CreateUser(String name, String email, String password, String lastName, String bornedAt) async {
    dynamic body = {
      "user": {
        "name": name,
        "email" : email,
        "lastName": lastName,
        "bornedAt": bornedAt
      },
      "auth": {
        "password" : password
      }
    };
    RequestResult<dynamic> response =  await RequestApi.request(endPoint: "users", requestType: RequestType.post, body: body);

    if(response.validResult){
      RequestResult<dynamic>("response", true, null);
      return response.result.toString();
    } else {
      return "ERROR :(";
    }
  }
  static Future<String> connect(String email, String password) async {
    dynamic body = {
      "password": password,
      "email" : email
    };

    RequestResult<dynamic> response =  await RequestApi.request(endPoint: "sessions", requestType: RequestType.post, body: body);
    if(response.validResult){
      RequestResult<String>("response", true, null);
      ConnexionData.isConnected = true;
      ConnexionData.token = jsonDecode(response.result)["token"];
      ConnexionData.userId = int.parse(Decoder.getPayload(ConnexionData.token).split('"')[3]);
      return ConnexionData.token;
    } else {
      return response.result.toString();
    }
  }
  static Future<List<ResourceElement>> showRes() async {
    dynamic body;
    if(ConnexionData.token != "") {
      body = {
        "token": ConnexionData.token
      };
    } else {
      body = {"null": "null"};
    }
    RequestResult<dynamic> response =  await RequestApi.request(endPoint: "resources", requestType: RequestType.get, body: body);

    if(response.validResult){
      if(jsonDecode(response.result)["token"] != null) {
        ConnexionData.token = jsonDecode(response.result)["token"];
      }
      var listeJson = jsonDecode(response.result);
      List<ResourceElement> listeRes = [];
      for (int i = 0; i<listeJson["result"].length; i++) {
        String commentCount = listeJson["result"][i]["comments"].length.toString();
        ResourceModel elementRes = ResourceModel.fromJson(listeJson["result"][i], commentCount);
        listeRes.add(ResourceElement(resourceModel: elementRes));
      }
      return listeRes;
    } else {
      return [];
    }
  }
  static Future<ResourceElement> showResById(int resId) async {
    dynamic body;
    if(ConnexionData.token != "") {
      body = {
        "token": ConnexionData.token
      };
    } else {
      body = {"null": "null"};
    }

    RequestResult<dynamic> response =  await RequestApi.request(endPoint: "resources/$resId", requestType: RequestType.get, body: body);

    // log("eraeraeqq" + jsonDecode(response.result));
    if(response.validResult){
      // if(jsonDecode(response.result)["token"] != null) {
      //   ConnexionData.token = jsonDecode(response.result)["token"];
      // }

      // log("tsuper est " + jsonDecode(response.result));

      log(response.result.runtimeType.toString() + "++=");
      Map resJson = jsonDecode(response.result);
      log(resJson.runtimeType.toString() + " &");

      ResourceModel resModel = ResourceModel.fromJson(resJson["result"], resJson["result"]["comments"].length.toString());
      ResourceElement elementRes = ResourceElement(resourceModel:resModel);
      return elementRes;
    } else {
      return ResourceElement(resourceModel: ResourceModel(-1,"","",[],"",1,"", "","","0", "", []));
    }
  }

  static Future<CommentModel> showCommentById(int comId) async {
    dynamic body;
    if(ConnexionData.token != "") {
      body = {
        "token": ConnexionData.token
      };
    } else {
      body = {"null": "null"};
    }
    RequestResult<dynamic> response =  await RequestApi.request(endPoint: "comments/$comId", requestType: RequestType.get, body: body);
    if(response.validResult){
      if(jsonDecode(response.result)["token"] != null) {
        ConnexionData.token = jsonDecode(response.result)["token"];
      }
      var resJson = jsonDecode(response.result)["result"];
      RequestResult<dynamic> userResp =  await RequestApi.request(endPoint: "users/"+ resJson["userId"], requestType: RequestType.get, body: body);
      var resJsonUser = jsonDecode(userResp.result)["result"];
      CommentModel comModel = CommentModel(resJsonUser["name"]+" "+resJsonUser["lastName"], resJson["text"], resJson["updatedAt"]);
      return comModel;
    } else {
      return CommentModel("inconnu", "erreur", "");
    }
  }

  static Future<bool> createResource(ResourceModel resourceModel) async {
    if(ConnexionData.token == "") {
      return false;
    }

    dynamic body = {
      "resource":{
        "title":resourceModel.title,
        "thumbnail":resourceModel.thumbnail,
        "type":resourceModel.type,
        "categoryId":1,
        "visibility":resourceModel.visibility,
        "body": {"ops":resourceModel.body}
      },
      "token":ConnexionData.token
    };
    RequestResult<dynamic> createResResp =  await RequestApi.request(endPoint: "resources", requestType: RequestType.post, body: body);


    if(createResResp.validResult == true){
      return true;
    } else {
      return false;
    }
  }

  static Future<List<CommentModel>> showComments(int resId) async {
    dynamic body;
    if(ConnexionData.token != "") {
      body = {
        "token": ConnexionData.token
      };
    } else {
      body = {"null": "null"};
    }
    RequestResult<dynamic> response =  await RequestApi.request(endPoint: "comments/$resId", requestType: RequestType.get, body: body);
    var i = 0;

    if(response.validResult){
      if(jsonDecode(response.result)["token"] != null) {
        ConnexionData.token = jsonDecode(response.result)["token"];
      }
      var listeJson = jsonDecode(response.result);

      List<CommentModel> listeRes = [];
      if(!listeJson["result"].isEmpty()) {
        for (int i = 0; i < listeJson.length; i++) {
          // String commentText = listeJson["result"][i]["text"];
          RequestResult<dynamic> userResp =  await RequestApi.request(endPoint: "users/"+ listeJson["result"][i]["userId"].toString(), requestType: RequestType.get, body: body);
          var resJsonUser = jsonDecode(userResp.result)["result"];
          CommentModel comModel = CommentModel(resJsonUser["name"]+" "+resJsonUser["lastName"], listeJson["result"][i]["text"], listeJson["result"][i]["updatedAt"]);
          listeRes.add(comModel);
        }
      }
      return listeRes;
    } else {
      return [];
    }
  }


  static Future<bool> postComment(int resId, String text) async {
    dynamic body = {
      "token": ConnexionData.token,
      "comment": {
        "text" : text,
        "resourceId": resId
      }
    };
    if(ConnexionData.token == "") {
        return false;
    }

    RequestResult<dynamic> response =  await RequestApi.request(endPoint: "comments", requestType: RequestType.post, body: body);
    if(response.validResult){
      return true;
    } else {
      return false;
    }
  }
}