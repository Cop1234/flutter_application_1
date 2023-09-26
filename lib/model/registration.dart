import 'package:flutter_application_1/model/login.dart';
import 'package:flutter_application_1/model/section.dart';
import 'package:flutter_application_1/model/user.dart';

class Registration {
  int? id;
  String? regisStatus;
  Section? section;
  User? user;

  // เปลี่ยนประเภทของ loginid เป็น Login

  Registration({
    this.id,
    this.regisStatus,
    this.section,
    this.user,
  });

  Map<String, dynamic> formRegistrationToJson() {
    return <String, dynamic>{
      'id': id,
      'regisStatus': regisStatus,
      'section': section?.formSectionToJson(),
      'user': user?.formUserToJson(),
    };
  }

  factory Registration.formJsonToRegistration(Map<String, dynamic> json) {
    return Registration(
      id: json["id"],
      regisStatus: json["regisStatus"],
      section: Section.formJsonToSection(json["section"]),
      user: User.formJsonToUser(json["user"]),
    );
  }
}
