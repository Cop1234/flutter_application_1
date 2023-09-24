import 'dart:convert';
import 'package:flutter_application_1/model/course.dart';
import 'package:flutter_application_1/model/room.dart';
import 'package:flutter_application_1/model/section.dart';
import 'package:flutter_application_1/model/user.dart';
import 'package:flutter_application_1/ws_config.dart';
import 'package:http/http.dart' as http;

class SectionController {
  Future listAllSection() async {
    var url = Uri.parse(baseURL + '/section/list');
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Section> list =
        jsonResponse.map((e) => Section.formJsonToSection(e)).toList();
    //print(list);
    return list;
  }

  Future listSectionsByUserId(String IdUser) async {
    var url = Uri.parse(baseURL + '/section/listbyiduser/' + IdUser);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Section> list =
        jsonResponse.map((e) => Section.formJsonToSection(e)).toList();
    print(list);
    return list;
  }

  Future get_Section(String id) async {
    var url = Uri.parse(baseURL + '/section/getbyid/' + id);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    Section section = Section.formJsonToSection(jsonResponse);
    return section;
  }

  Future deleteSection(String id) async {
    var url = Uri.parse(baseURL + "/section/delete/" + id);
    http.Response response = await http.delete(url);
    return response;
  }

  Future addSection(String startTime, String duration, String sectionNumber,
      String type, String userId, String courseId, String roomId) async {
    Map data = {
      "startTime": startTime,
      "duration": duration,
      "sectionNumber": sectionNumber,
      "type": type,
      "userId": userId,
      "courseId": courseId,
      "roomId": roomId,
    };
    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/section/add");
    http.Response response =
        await http.post(url, headers: headers, body: jsonData);
    print(response.body);
    return response;
  }
}
