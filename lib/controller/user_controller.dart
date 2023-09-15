import 'dart:convert';
import 'package:flutter_application_1/ws_config.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:http/http.dart' as http;

class UserController {
  Future get_User(String username) async {
    var url = Uri.parse(baseURL + '/user/getbyusername/' + username);

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    User user = User.formUserToJson(jsonResponse);
    return user;
  }

  Future listAllTeacher() async {
    var url = Uri.parse(baseURL + '/teacher/list');

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<User> list = jsonResponse.map((e) => User.formUserToJson(e)).toList();
    return list;
  }

  Future addTeacher(String userid, String email, String fname, String lname,
      String birthdate, String gender) async {
    Map data = {
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

  Future deleteTeacher(String id) async {
    var url = Uri.parse(baseURL + "/teacher/delete/" + id);

    http.Response response = await http.delete(url);

    return response;
  }

  Future updateTeacher(User user) async {
    Map<String, dynamic> data = user.formUserToJson();

    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/teacher/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }
}
