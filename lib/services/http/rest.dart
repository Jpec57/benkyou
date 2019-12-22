import 'package:http/http.dart';

Future<dynamic> makeGetRequest(String url) async {
  Response response = await get(url);

  int statusCode = response.statusCode;
  if (statusCode >= 500){
    print("Oups");
  }
//  Map<String, String> headers = response.headers;
  String json = response.body;
  return json;
}

makePostRequest(String url, String json) async {
  Map<String, String> headers = {"Content-type": "application/json"};
  Response response = await post(url, headers: headers, body: json);
  int statusCode = response.statusCode;
  if (statusCode >= 500){
    print("Oups");
  }
  return null;
}

makeDeleteRequest(String url) async {
  Response response = await delete(url);
  int statusCode = response.statusCode;
  if (statusCode >= 500){
    print("Oups");
  }
}