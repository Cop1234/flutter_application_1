import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_application_1/model/registration.dart';
import 'package:http/http.dart' as http;
import '../ws_config.dart';

class RegistrationController {
  Future upload(Uint8List file, String? filename, String id) async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file,
        filename: filename,
        // Provide the desired file name and extension
      ),
      'id': id
    });
    String url = baseURL + '/registrations/upload';
    Response response = await dio.post(url, data: formData);
    print("Student : " + response.data);
    return response.statusCode;
  }

  Future deleteRegistration(String id) async {
    var url = Uri.parse(baseURL + "/registrations/delete/" + id);
    http.Response response = await http.delete(url);
    return response;
  }

  Future listAllRegistration() async {
    var url = Uri.parse(baseURL + '/registrations/list');
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Registration> list = jsonResponse
        .map((e) => Registration.formJsonToRegistration(e))
        .toList();
    //print(list);
    return list;
  }

  Future get_ViewSubject(String id) async {
    var url = Uri.parse(baseURL + '/registrations/stu_listsubject/' + id);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Registration> list = jsonResponse
        .map((e) => Registration.formJsonToRegistration(e))
        .toList();
    //print(list);
    return list;
  }

  Future stu_listsubject(String IdUser) async {
    var url = Uri.parse(baseURL + '/registrations/stu_listsubject/' + IdUser);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Registration> list = jsonResponse
        .map((e) => Registration.formJsonToRegistration(e))
        .toList();
    print(list);
    return list;
  }

  Future do_getViewStudent(String idsec) async {
    var url = Uri.parse(baseURL + '/registrations/do_getViewStudent/' + idsec);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Registration> list = jsonResponse
        .map((e) => Registration.formJsonToRegistration(e))
        .toList();
    print(list);
    return list;
  }

  Future do_update(String userid, String idsec) async {
    Map data = {
      "userid": userid,
      "idsec": idsec,
    };
    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/registrations/do_update");
    http.Response response =
        await http.post(url, headers: headers, body: jsonData);
    print(response.body);
    return response;
  }

  Future get_RegistrationIdBySectionIdandIdUser(
      String sectionId, String IdUser) async {
    var url = Uri.parse(
        baseURL + '/registrations/getregid/' + sectionId + '/' + IdUser);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    Registration registration =
        Registration.formJsonToRegistration(jsonResponse);
    return registration;
  }
}
