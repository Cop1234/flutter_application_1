import 'dart:convert';
import 'package:flutter_application_1/model/course.dart';
import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/ws_config.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';

class CourseController {
  Future listAllCourse() async {
    var url = Uri.parse(baseURL + '/course/list');
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Course> list =
        jsonResponse.map((e) => Course.formCourseToJson(e)).toList();
    //print(list);
    return list;
  }

  Future get_Course(String id) async {
    var url = Uri.parse(baseURL + '/course/getbyid/' + id);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    Course course = Course.formCourseToJson(jsonResponse);
    return course;
  }

  Future deleteCourse(String id) async {
    var url = Uri.parse(baseURL + "/course/delete/" + id);
    http.Response response = await http.delete(url);
    return response;
  }

  Future addCourse(
      String subjectId, String userId, String term, String semester) async {
    Map data = {
      "subjectId": subjectId,
      "userId": userId,
      "term": term,
      "semester": semester,
    };
    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/course/add");
    http.Response response =
        await http.post(url, headers: headers, body: jsonData);
    print(response.body);
    return response;
  }
}
