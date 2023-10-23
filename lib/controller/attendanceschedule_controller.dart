import 'dart:typed_data';

import 'package:flutter_application_1/model/attendanceSchedule.dart';
import 'package:flutter_application_1/ws_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class AttendanceScheduleController {
  Future listAllAttendanceSchedule() async {
    var url = Uri.parse(baseURL + '/attendanceschedule/list');
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<AttendanceSchedule> list = jsonResponse
        .map((e) => AttendanceSchedule.formJsonToAttendanceSchedule(e))
        .toList();
    return list;
  }

  Future listAttendanceScheduleByUserId(String RegistrationId) async {
    var url = Uri.parse(
        baseURL + '/attendanceschedule/listbyregistrationid/' + RegistrationId);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<AttendanceSchedule> list = jsonResponse
        .map((e) => AttendanceSchedule.formJsonToAttendanceSchedule(e))
        .toList();
    return list;
  }

  Future get_AttendanceSchedule(String id) async {
    var url = Uri.parse(baseURL + '/attendanceschedule/getbyid/' + id);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    AttendanceSchedule attendanceSchedule =
        AttendanceSchedule.formJsonToAttendanceSchedule(jsonResponse);
    return attendanceSchedule;
  }

  Future deleteAttendanceSchedule(String id) async {
    var url = Uri.parse(baseURL + "/attendanceschedule/delete/" + id);
    http.Response response = await http.delete(url);
    return response;
  }

  Future addAttendanceSchedule(
      String regId, String weekNo, String checkInTime, String status) async {
    Map data = {
      "regId": regId,
      "weekNo": weekNo,
      "checkInTime": checkInTime,
      "status": status,
    };
    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/attendanceschedule/add");
    http.Response response =
        await http.post(url, headers: headers, body: jsonData);
    return response;
  }

  Future updateAttendanceSchedule(String id, String regId, String weekNo,
      String checkInTime, String status) async {
    Map data = {
      "id": id,
      "regId": regId,
      "weekNo": weekNo,
      "checkInTime": checkInTime,
      "status": status,
    };
    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/attendanceschedule/update");
    http.Response response =
        await http.post(url, headers: headers, body: jsonData);
    return response;
  }

  Future listAttendanceScheduleByWeek(String week, String secid) async {
    var url = Uri.parse(
        baseURL + '/attendanceschedule/getbyweek/' + week + "/" + secid);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<AttendanceSchedule> list = jsonResponse
        .map((e) => AttendanceSchedule.formJsonToAttendanceSchedule(e))
        .toList();
    return list;
  }

  Future get_ListAttendanceStudent(
      String week, String secid, String userID) async {
    var url = Uri.parse(baseURL +
        '/attendanceschedule/get_AttendanceStudent/' +
        week +
        "/" +
        secid +
        "/" +
        userID);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<AttendanceSchedule> list = jsonResponse
        .map((e) => AttendanceSchedule.formJsonToAttendanceSchedule(e))
        .toList();
    return list;
  }

  Future updateAttendanceStatus(List<Map<String, dynamic>> scheduleList) async {
    try {
      final response = await http.put(
        Uri.parse(baseURL +
            '/attendanceschedule/updatestastus'), // เปลี่ยน URL ไปยัง URL ของ API ของคุณ
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(scheduleList),
      );
      return response;
    } catch (e) {
      return e;
      // print('Error: $e');
    }
  }

  Future listAttendanceScheduleByRegistrationId(String RegistrationId) async {
    var url = Uri.parse(
        baseURL + '/attendanceschedule/listbyregistrationid/' + RegistrationId);
    http.Response response = await http.get(url);
    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<AttendanceSchedule> list = jsonResponse
        .map((e) => AttendanceSchedule.formJsonToAttendanceSchedule(e))
        .toList();
    print(list);
    return list;
  }
}
