import 'package:flutter_application_1/model/registration.dart';

class AttendanceSchedule {
  int? id;
  Registration? registration;
  int? weekNo;
  String? checkInTime;
  String? status;

  AttendanceSchedule({
    this.id,
    this.registration,
    this.weekNo,
    this.checkInTime,
    this.status,
  });

  Map<String, dynamic> formAttendanceScheduleToJson() {
    return <String, dynamic>{
      'id': id,
      'registration': registration?.formRegistrationToJson(),
      'weekNo': weekNo,
      'checkInTime': checkInTime,
      'status': status,
    };
  }

  factory AttendanceSchedule.formJsonToAttendanceSchedule(
      Map<String, dynamic> json) {
    return AttendanceSchedule(
      id: json["id"],
      registration: Registration.formJsonToRegistration(json["registration"]),
      weekNo: json["weekNo"],
      checkInTime: json["checkInTime"],
      status: json["status"],
    );
  }
}
