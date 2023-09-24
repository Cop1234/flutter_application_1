import 'package:flutter_application_1/model/subject.dart';
import 'package:flutter_application_1/model/user.dart';

class Course {
  int? id;
  Subject? subject;
  User? user;
  int? term;
  int? semester;

  Course({
    this.id,
    this.subject,
    this.user,
    this.term,
    this.semester,
  });

  Map<String, dynamic> formCourseToJson() {
    return <String, dynamic>{
      'id': id,
      'subject': subject?.formSubjectToJson(),
      'user': user?.formUserToJson(),
      'term': term,
      'semester': semester,
    };
  }

  factory Course.formJsonToCourse(Map<String, dynamic> json) {
    return Course(
      id: json["id"],
      subject: Subject.formJsonToSubject(json["subject"]),
      user: User.formJsonToUser(json["user"]),
      term: json["term"],
      semester: json["semester"],
    );
  }
}
