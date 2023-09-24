import 'package:flutter_application_1/model/course.dart';
import 'package:flutter_application_1/model/room.dart';
import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/model/user.dart';

class Section {
  int? id;
  String? startTime;
  int? duration;
  String? sectionNumber;
  String? type;
  User? user;
  Course? course;
  Room? room;

  Section({
    this.id,
    this.startTime,
    this.duration,
    this.sectionNumber,
    this.type,
    this.user,
    this.course,
    this.room,
  });

  Map<String, dynamic> formSectionToJson() {
    return <String, dynamic>{
      'id': id,
      'startTime': startTime,
      'duration': duration,
      'sectionNumber': sectionNumber,
      'type': type,
      'user': user?.formUserToJson(),
      'course': course?.formCourseToJson(),
      'room': room?.formRoomToJson(),
    };
  }

  factory Section.formJsonToSection(Map<String, dynamic> json) {
    return Section(
      id: json["id"],
      startTime: json["startTime"],
      duration: json["duration"],
      sectionNumber: json["sectionNumber"],
      type: json["type"],
      user: User.formJsonToUser(json["user"]),
      course: Course.formJsonToCourse(json["course"]),
      room: Room.formJsonToRoom(json["room"]),
    );
  }
}
