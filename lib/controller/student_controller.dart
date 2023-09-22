import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../ws_config.dart';

class StudentController {
  Future listAllStudent() async {
    var url = Uri.parse(baseURL + '/student/list');
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<User> list = jsonResponse.map((e) => User.formJsonToUser(e)).toList();
    //print(list);
    return list;
  }

  Future upload(Uint8List file, String? filename) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file,
        filename: filename, // Provide the desired file name and extension
      ),
    });

    // Adjust the URL to your Spring Boot server endpoint
    String url = baseURL + '/student/upload';

    Response response = await dio.post(url, data: formData);

    print("Student : " + response.data);
    return response.statusCode;
  }

  Future deleteStudent(String id) async {
    var url = Uri.parse(baseURL + "/student/delete/" + id);

    http.Response response = await http.delete(url);

    return response;
  }

  Future get_Userid(String id) async {
    var url = Uri.parse(baseURL + '/student/getbyid/' + id);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    User user = User.formJsonToUser(jsonResponse);
    print(user);
    return user;
  }

  Future updateStudent(String id, String email, String fname, String lname,
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
    var url = Uri.parse(baseURL + '/student/update');
    http.Response response =
        await http.put(url, headers: headers, body: jsonData);
    return response;
  }
}
