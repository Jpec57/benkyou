import 'dart:convert';

import 'package:http/http.dart';

Future<dynamic> makeGetRequest(String url) async {
  Response response = await get(url);

  int statusCode = response.statusCode;
  if (statusCode >= 500){
    print("Oups");
  }
  Map<String, String> headers = response.headers;
  // TODO check token
  String json = response.body;
  // TODO convert json to object...

  return json;
}

makePostRequest(String url, String json) async {
  Map<String, String> headers = {"Content-type": "application/json"};
//  String json = '{"title": "Hello", "body": "body text", "userId": 1}';
  Response response = await post(url, headers: headers, body: json);
  int statusCode = response.statusCode;
  if (statusCode >= 500){
    print("Oups");
  }
  // this API passes back the id of the new item added to the body
  String body = response.body;
  // {
  //   "title": "Hello",
  //   "body": "body text",
  //   "userId": 1,
  //   "id": 101
  // }

  return null;
}

makeDeleteRequest(String url) async {
  Response response = await delete(url);
  int statusCode = response.statusCode;
  if (statusCode >= 500){
    print("Oups");
  }
}