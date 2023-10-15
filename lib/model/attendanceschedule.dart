import 'package:flutter_application_1/model/registration.dart';
import 'package:intl/intl.dart';

class AttendanceSchedule {
  int? id;
  Registration? registration;
  int? weekNo;
  String? checkInTime;
  String? status;

  AttendanceSchedule({
    this.weekNo,
    this.checkInTime,
    this.registration,
    this.id,
    this.status,
  });

  Map<String, dynamic> formAttendanceScheduleToJson() {
    return <String, dynamic>{
      'weekNo': weekNo,
      'checkInTime': checkInTime,
      'registration': registration?.formRegistrationToJson(),
      'id': id,
      'status': status,
    };
  }

  factory AttendanceSchedule.formJsonToAttendanceSchedule(
      Map<String, dynamic> json) {
    return AttendanceSchedule(
      weekNo: json["weekNo"],
      checkInTime: json["checkInTime"],
      registration: Registration.formJsonToRegistration(json["registration"]),
      id: json["id"],
      status: json["status"],
    );
  }
}
