import 'package:flutter_application_1/model/login.dart';
import 'package:flutter_application_1/model/section.dart';
import 'package:flutter_application_1/model/user.dart';

class registration {
  int? id;
  String? regisStatus;
  Section? section;
  User? user;

  // เปลี่ยนประเภทของ loginid เป็น Login

  registration({
    this.id,
    this.regisStatus,
    this.section,
    this.user,
  });

  Map<String, dynamic> formUserToJson() {
    return <String, dynamic>{
      'id': id,
      'regisStatus': regisStatus,
      'section': section?.formSectionToJson(),
      'user': user?.formUserToJson(),
    };
  }

  factory registration.formJsonToUser(Map<String, dynamic> json) {
    return registration(
      id: json["id"],
      regisStatus: json["regisStatus"],
      section: Section.formJsonToSection(json["section"]),
      user: User.formJsonToUser(json["user"]),
    );
  }
}
