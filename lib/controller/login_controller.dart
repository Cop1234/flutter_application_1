import 'dart:convert';
import 'package:flutter_application_1/model/login.dart';
import 'package:flutter_application_1/ws_config.dart';
import 'package:http/http.dart' as http;

class LoginController {
  Future doLogin(String username, String password) async {
    Map data = {"username": username, "password": password};

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/login/do_login");

    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    print(response.body);
    return response;
  }

  Future get_ListLogin() async {
    var url = Uri.parse(baseURL + '/login/list');

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Login> list =
        jsonResponse.map((e) => Login.formJsonToLogin(e)).toList();
    return list;
  }

  Future get_Login(String username) async {
    var url = Uri.parse(baseURL + '/login/getbyusername/' + username);

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    Login login = Login.formJsonToLogin(jsonResponse);
    return login;
  }

  Future change_Password(String username, String password) async {
    Map data = {"username": username, "password": password};

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/login/change_password");

    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    return response;
  }
}
