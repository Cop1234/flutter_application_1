import 'dart:convert';
import 'package:flutter_application_1/ws_config.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:http/http.dart' as http;

class UserController {
  Future get_UserByUsername(String username) async {
    var url = Uri.parse(baseURL + '/user/getbyusername/' + username);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    User user = User.formJsonToUser(jsonResponse);
    return user;
  }

  Future listAllTeacher() async {
    var url = Uri.parse(baseURL + '/teacher/list');
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<User> list = jsonResponse.map((e) => User.formJsonToUser(e)).toList();
    //print(list);
    return list;
  }

  Future deleteTeacher(String id) async {
    var url = Uri.parse(baseURL + "/teacher/delete/" + id);
    http.Response response = await http.delete(url);
    return response;
  }

  Future updateTeacher(String id, String email, String fname, String lname,
      String birthdate, String gender, String loginid, String password) async {
    Map data = {
      "id": id,
      "email": email,
      "fname": fname,
      "lname": lname,
      "birthdate": birthdate,
      "gender": gender,
      "loginid": loginid,
      "password": password
    };
    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + '/teacher/update');
    http.Response response =
        await http.put(url, headers: headers, body: jsonData);
    return response;
  }

  Future addTeacher(String logid, String password, String userid, String email,
      String fname, String lname, String birthdate, String gender) async {
    Map data = {
      "logid": logid,
      "password": password,
      "userid": userid,
      "email": email,
      "fname": fname,
      "lname": lname,
      "birthdate": birthdate,
      "gender": gender
    };
    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/teacher/add");
    http.Response response =
        await http.post(url, headers: headers, body: jsonData);
    print(response.body);
    return response;
  }

  Future get_Userid(String id) async {
    var url = Uri.parse(baseURL + '/teacher/getbyid/' + id);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    User user = User.formJsonToUser(jsonResponse);
    print(user);
    return user;
  }
}
