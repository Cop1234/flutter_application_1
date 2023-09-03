import 'dart:convert';
import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/ws_config.dart';
import 'package:http/http.dart' as http;

class SubjectController {
  Future addSubject(String subjectId, String subjectName, String detail,
      String credit) async {
    Map data = {
      "subjectId": subjectId,
      "subjectName": subjectName,
      "detail": detail,
      "credit": credit
    };

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/subject/add");

    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    print(response.body);
    return response;
  }

  Future listAllSubjects() async {
    var url = Uri.parse(baseURL + '/subject/list');

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Subject> list =
        jsonResponse.map((e) => Subject.formSubjectToJson(e)).toList();
    return list;
  }

  Future get_Subject(String subjectId) async {
    var url = Uri.parse(baseURL + '/subject/getbyid/' + subjectId);

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    Subject subject = Subject.formSubjectToJson(jsonResponse);
    return subject;
  }

  Future update_Subject(Subject subject) async {
    Map<String, dynamic> data = subject.formSubjectToJson();

    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/subject/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }

  Future deleteSubject(String subjectId) async {
    var url = Uri.parse(baseURL + "/subject/delete/" + subjectId);

    http.Response response = await http.delete(url);

    return response;
  }
}
