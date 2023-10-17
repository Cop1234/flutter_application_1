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
    //print(list);
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
    print(list);
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
    print(response.body);
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
    print(response.body);
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
    print(list);
    print(response);
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
    print(list);
    print("response : " + response.body);
    return list;
  }

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
}
